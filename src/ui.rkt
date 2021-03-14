#lang racket/base

(require racket/gui)
(require "logic.rkt")

(provide bCEj splash-screen run-game)

(define (bCEj X)
  (cond [(not (integer? X)) (raise "Expected an integer numbe rof players")]
        [(or (< X 1) (> X 3)) (raise "There may only be one, two, or three players")])

  (let*
    ([names-dialog (new dialog% [label "Player nams"])]
     [name-fields (add-name-fields names-dialog X 1 empty)])

    (new button%
         [parent names-dialog]
         [label "Play"]
         [callback
           (λ (button event)
              (let ([player-names
                      (map (λ (field) (string-trim (send field get-value)))
                           name-fields)])

                (when [empty? (filter (compose not non-empty-string?) player-names)]
                  (send names-dialog show #f)
                  (run-game player-names (splash-screen)))))])

    (send names-dialog show #t)))

(define (splash-screen)
  (let* ([splashes '("aces" "honor_clubs" "honor_diamonds" "honor_hearts" "honor_spades")]
         [splash (load-bitmap
                   (string-append "splash/" (list-ref splashes (random (length splashes)))))]

         [width (send splash get-width)]
         [height (send splash get-height)]

         [screen (new frame%
                      [label ""]
                      [style '(float no-resize-border no-caption no-system-menu)])]

         [pane (new vertical-pane% [parent screen])])

    (new canvas%
         [parent pane]
         [min-width (quotient width 3)]
         [min-height (quotient height 3)]
         [paint-callback
           (λ (canvas dc)

              (send dc set-scale (/ 1 3) (/ 1 3))
              (send dc draw-bitmap splash 0 0)

              (let*
                ([font (send the-font-list find-or-create-font 130 'default 'normal 'normal)]
                 [text-width
                   (λ (text) (call-with-values
                                (λ () (send dc get-text-extent text font))
                                (λ (width height baseline padding) width)))]

                 [bla (text-width "Bla")]
                 [ce (text-width "CE")]
                 [jack (text-width "Jack")]

                 [start-x (quotient (- width bla ce jack) 2)]
                 [start-y (quotient (* height 3) 4)]

                 [black (send dc get-text-foreground)]
                 [red (send the-color-database find-color "red")])

                (send dc set-font font)
                (send dc draw-text "Bla" start-x start-y)

                (send dc set-text-foreground red)
                (send dc draw-text "CE" (+ start-x bla) start-y)

                (send dc set-text-foreground black)
                (send dc draw-text "Jack" (+ start-x bla ce) start-y)))])

    (let ([gauge (new gauge%
                      [parent pane]
                      [label "Loading... "]
                      ; The real range will be set later
                      [range 1])])

      (send screen show #t)
      (yield)
      gauge)))

(define (run-game player-names [splash-gauge #f])
  (letrec
    ([window (new frame%
                  [label "BlaCEJack"]
                  [width 800]
                  [height 600]
                  [alignment '(center top)])]

     [croupier-container (player-container window "Croupier")]
     [game-table (new horizontal-panel% [parent window])]
     [player-containers (map (curry player-container game-table) player-names)]

     [bottom-row (new horizontal-panel%
                      [parent window]
                      [alignment '(center center)])]

     [current-player (dynamic-label bottom-row)]

     [action-button
       (λ (parameter label)
          (new button%
               [parent bottom-row]
               [label label]
               [callback
                 (λ (button event)
                    (enable-action-buttons #f)
                    ((parameter)))]))]

     [on-hang-up (make-parameter #f)]
     [on-take-card (make-parameter 0)]

     [take-card-button (action-button on-take-card "Take card")]
     [hang-up-button (action-button on-hang-up "Hang up")]

     [enable-action-buttons
       (λ (enable?)
          (send take-card-button enable enable?)
          (send hang-up-button enable enable?))]

     [do-turn
       (λ (game player-id player)
          (on-hang-up (λ () (rotate-player (hang game player-id) player-id)))
          (on-take-card
            (λ ()
               (rotate-player
                 (grab game (list-get player-containers player-id) player-id)
                 player-id)))

          (send current-player set-label (name player)))]

     [rotate-player
       (λ (game player-id)
          (when [not (active? (get-player game player-id))]
            (send (container-panel (list-get player-containers player-id)) enable #f))

          (match (next-turn game player-id)
                 [(list) ; No active players are left

                  (send bottom-row show #f)
                  (end-of-game game croupier-container)]

                 [(cons next-id next)

                  (enable-action-buttons #t)
                  (do-turn game next-id next)]))])

    (send (container-panel croupier-container) enable #f)
    (send (score-label croupier-container) show #f)
    (send bottom-row show #f)

    (when splash-gauge
      #| +1 for all setup operations before bitmap loading
      || +1 for the bitmap preload for 'hidden
      || +52 for every other preloaded bitmap
      ||#
      (send splash-gauge set-range (+ 1 1 52))
      (progress splash-gauge))

    (preload-bitmaps splash-gauge)

    (when splash-gauge (send (send splash-gauge get-top-level-window) show #f))
    (send window show #t)

    (sleep/yield 0.5)

    (letrec
      ([initial-grab-for-players
         (λ (game containers player-ids)
            (cond [(empty? player-ids) game]
                  [else (initial-grab-for-players
                          (initial-grab game (car containers) (car player-ids))
                          (cdr containers) (cdr player-ids))]))]

       [empty-game (new-game player-names)]
       [game (initial-grab-for-players
               (initial-grab empty-game croupier-container 'croupier)
               player-containers (range (length (players empty-game))))])

      (do-turn game 0 (car (players game))))

    (send bottom-row show #t)))

(define (end-of-game game croupier-container)
  (send (container-panel croupier-container) enable #t)
  (send (container-panel croupier-container) refresh)
  (send (score-label croupier-container) show #t)

  (letrec
    ([grab-last-croupier-cards
       (λ (game)
          (when [not (game-finished? game)]
            (grab-last-croupier-cards (grab game croupier-container 'croupier))))])

    (grab-last-croupier-cards game)))

(define (add-name-fields dialog up-to next fields)
  (cond
    [(> next up-to) (reverse fields)]
    [else
      (add-name-fields
        dialog
        up-to
        (+ next 1)
        (cons (new text-field%
               [parent dialog]
               [label
                 (string-append "Player #"
                                (number->string next))])
              fields))]))

(define (dynamic-label parent)
  (new message% [parent parent] [label ""] [auto-resize #t]))

(define (player-container parent name)
  (let*
    ([panel (new vertical-panel% [parent parent])]
     [name-label (new message% [parent panel] [label name])]
     [score-label (dynamic-label panel)]

     [current-cards (make-parameter '())]
     [card-canvas (new canvas%
                       [parent panel]
                       [style '(border transparent)]
                       [paint-callback
                         (λ (canvas dc)
                            (redraw-cards canvas dc (current-cards)))])]

     [container (list panel score-label card-canvas current-cards)])

    (update-score container 0)
    container))

(define container-panel car)
(define score-label cadr)
(define card-canvas caddr)
(define current-cards cadddr)

(define (initial-grab game container player-id)
  (cond [(ready? (get-player game player-id)) game]
        [else (initial-grab (grab game container player-id) container player-id)]))

(define (grab game container player-id)
  (match (take-card game)
         [(cons card game)
          (let*
            ([game (put-card game player-id card)]
             [player (get-player game player-id)]

             [cards (reverse (held-cards player))]
             [show-first (or (empty? cards)
                             (not (eqv? player-id 'croupier))
                             (send (container-panel container) is-enabled?))]

             [cards (cond [show-first cards]
                          [else (cons 'hidden (cdr cards))])])

            (play-sound "../assets/card-flip.wav" #t)

            (update-cards container cards)
            (update-score container (score player))

            (sleep/yield 0.25)
            game)]))

(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))

(define (update-cards container cards)
  ((current-cards container) cards)
  (send (card-canvas container) refresh-now))

(define (redraw-cards canvas dc cards)
  (letrec 
    ([spacing (λ (bitmap) (quotient (send bitmap get-width) 4))]
     [scale (λ (bitmap) (/ (send canvas get-height) (send bitmap get-height)))]

     [redraw-cards
       (λ (offset cards)
          (when [not (empty? cards)]
            (let*
              ([bitmap (card-bitmap (car cards))]
               [scale (scale bitmap)])

              (send dc set-scale scale scale)
              (send dc draw-bitmap bitmap offset 0)

              (redraw-cards (+ offset (spacing bitmap)) (cdr cards)))))]

     #| We want a centered card stack, therefore:
     || base-offset = canvas-width/2 - stack-width/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-width))/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-spacing * 4))/2
     ||             = (real-canvas-width/scale - (n + 3) * card-spacing)/2
     |#
     [base-offset
       (when [not (empty? cards)]
         (/ (- (/ (send canvas get-width) (scale (card-bitmap (car cards))))
               (* (+ (length cards) 3)
                  (spacing (card-bitmap (car cards)))))
            2))])

    (redraw-cards base-offset cards)))

(define (card-bitmap card)
  (cond
    [(hash-has-key? loaded-bitmaps card) (hash-ref loaded-bitmaps card)]
    [else
      (let*
        ([value
           (match (card-value card)
                  [(or 1 11) "A"]
                  ['jack "J"]
                  ['queen "Q"]
                  ['king "K"]
                  [_ (number->string (card-value card))])]

         [symbol
           (match (card-symbol card)
                  ['pikes "S"]
                  ['hearts "H"]
                  ['clovers "C"]
                  ['diamonds "D"])]

         [bitmap (load-bitmap (string-append "cards/" value symbol))])

        (hash-set! loaded-bitmaps card bitmap)
        bitmap)]))

(define (load-bitmap path)
  (read-bitmap (string-append "../assets/" path ".png") 'png))

(define loaded-bitmaps (make-hash))

(define (preload-bitmaps [gauge #f])
  (when [not (hash-has-key? loaded-bitmaps 'hidden)]
    (hash-set! loaded-bitmaps 'hidden (load-bitmap "cards/red_back")))
  (progress gauge)

  (letrec
    ([preload-bitmaps
       (λ (cards)
          (when [not (empty? cards)]
            (yield)
            (card-bitmap (car cards))

            (progress gauge)
            (preload-bitmaps (cdr cards))))])

    (preload-bitmaps (cartesian-product '(1 2 3 4 5 6 7 8 9 10 jack queen king 11)
                                        '(pikes hearts clovers diamonds)))))

(define (progress gauge)
  (send gauge set-value (min (+ 1 (send gauge get-value)) (send gauge get-range))))
