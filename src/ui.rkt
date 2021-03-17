#lang racket/base

(require racket/gui racket/runtime-path)
(require "logic.rkt")

(provide bCEj start-game)

(define-runtime-path assets-path "../assets")

(define (bCEj X)
  (cond [(not (integer? X)) (raise "Expected an integer numbe rof players")]
        [(or (< X 1) (> X 3)) (raise "There may only be one, two, or three players")])

  (let*
    ([names-dialog (new dialog% [label "Player names"])]
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
                  (start-game player-names))))])

    (send names-dialog show #t)))

(define (start-game player-names)
  (run-game player-names (splash-screen)))

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
                 [text-width (λ (text) (get-text-width dc text font))]

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
    ([window
       (new frame%
            [label "BlaCEJack"]
            [width 800]
            [height 600]
            [alignment '(center top)])]

     [top-row (new horizontal-panel% [parent window])]
     [game-table (new horizontal-panel% [parent window])]
     [bottom-panel (new horizontal-panel%
                        [parent window]
                        [alignment '(center center)])]

     [croupier-container (game-container top-row "Croupier")]
     [deck (game-container top-row "Deck" draw-deck 52)]

     [player-containers (map (curry game-container game-table) player-names)]
     [current-player
       (new message%
            [parent
              (new horizontal-pane%
                   [parent bottom-panel]
                   [alignment '(center center)])]

            [label (cdar (quicksort (map (λ (name) (cons (string-length name) name))
                                         player-names)
                                    (λ (a b) (> (car a) (car b)))))]

            [font (send the-font-list find-or-create-font 30 'default 'normal 'bold)])]

     [action-pane
       (new vertical-pane%
            [parent bottom-panel]
            [alignment '(left center)])]

     [action-button
       (λ (parameter label)
          (new button%
               [parent action-pane]
               [label label]
               [callback
                 (λ (button event)
                    (enable-action-buttons #f)
                    ((parameter)))]))]

     [on-stand-up (make-parameter #f)]
     [on-take-card (make-parameter 0)]

     [take-card-button (action-button on-take-card "Take card")]
     [stand-up-button (action-button on-stand-up "Stand")]

     [enable-action-buttons
       (λ (enable?)
          (send take-card-button enable enable?)
          (send stand-up-button enable enable?))]

     [do-turn
       (λ (game player-id player)
          (on-stand-up (λ () (rotate-player (stand game player-id) player-id)))
          (on-take-card
            (λ ()
               (rotate-player
                 (grab game deck (list-get player-containers player-id) player-id)
                 player-id)))

          (send current-player set-label (name player)))]

     [rotate-player
       (λ (game player-id)
          (when [not (active? (get-player game player-id))]
            (send (container-panel (list-get player-containers player-id)) enable #f))

          (match (next-turn game player-id)
                 [(list) ; No active players are left

                  (send bottom-panel show #f)
                  (end-of-game game deck croupier-container window
                               (λ (restart?)
                                  (send window show #f)
                                  (when restart? (run-game player-names))))]

                 [(cons next-id next)

                  (enable-action-buttons #t)
                  (do-turn game next-id next)]))])

    (send (container-panel croupier-container) enable #f)
    (send (score-label croupier-container) show #f)
    (send bottom-panel show #f)

    (when splash-gauge
      #| +1 for all operations that go before bitmap loading
      || +2 for 'hidden and 'large-stack
      || +52 for every other preloaded bitmap
      ||#
      (send splash-gauge set-range (+ 1 2 52))
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
                          (initial-grab game deck (car containers) (car player-ids))
                          (cdr containers) (cdr player-ids))]))]

       [empty-game (new-game player-names)]
       [game (initial-grab-for-players
               (initial-grab empty-game deck croupier-container 'croupier)
               player-containers (range (length (players empty-game))))])

      (do-turn game 0 (car (players game))))

    (send bottom-panel show #t)))

(define (end-of-game game deck croupier-container window then)
  (flip 0.25
    (λ ()
       (send (container-panel croupier-container) enable #t)
       (send (score-label croupier-container) show #t)
       (update-cards croupier-container
                     (shown-cards (reverse (held-cards (croupier game)))
                                  croupier-container 'croupier))))

  (letrec
    ([grab-last-croupier-cards
       (λ (game)
          (cond [(game-finished? game) game]
                [else (grab-last-croupier-cards
                        (grab game deck croupier-container 'croupier))]))])

    (show-score (grab-last-croupier-cards game) window then)))

(define (show-score game window then)
  (letrec
    ([dialog (new dialog%
                  [parent window]
                  [label "Scoreboard"])]

     [rows
       (append
         (list
           '("No." "Name" "Score" "Outcome")
           '("" "" "" "") ; Fake padding

           (list "" "Croupier"
                 (number->string (score (croupier game)))
                 (cond [(lost? (croupier game)) "Loses if player wins"]
                       [else ""])))

         (map
           (curry apply
                  (λ (position name score outcome)
                     (list (string-append "#" (number->string (+ position 1)))
                           name (number->string score)
                           (match outcome
                                  ['tie "Tie"]
                                  ['wins "Wins"]
                                  ['loses "Loses"]))))

           (scoreboard game)))]

     [column-widths
       (λ (dc)
          (map (λ (column)
                  (apply max
                         (map (compose (curry get-text-width dc)
                                       (λ (row) (list-ref row column)))

                              rows)))

               (range (length (car rows)))))]

     [draw-cell
       (λ (dc rows widths all-widths x-offset y-offset)
          (when [not (empty? rows)]
            (cond [(empty? (car rows))
                   (draw-cell dc (cdr rows) all-widths all-widths 0 (+ y-offset 15))]

                  [else (send dc draw-text (car (car rows)) x-offset y-offset)
                        (draw-cell dc (cons (cdr (car rows)) (cdr rows))
                                   (cdr widths) all-widths
                                   (+ x-offset (car widths) 20) y-offset)])))])

    (new canvas% 
         [parent dialog]
         [style '(transparent)]
         [min-height (* 20 (length rows))]
         [min-width
           (apply (compose exact-round +)
                  (map (curry + 20)
                       (column-widths (send (new canvas% [parent dialog]) get-dc))))]

         [paint-callback
           (λ (canvas dc)
              (let ([widths (column-widths dc)])
                (draw-cell dc rows widths widths 0 0)))])

    (let*
      ([bottom-row (new horizontal-pane%
                        [parent dialog]
                        [alignment '(center top)])]

       [final-action
         (λ (label restart?)
            (new button%
                 [parent bottom-row]
                 [label label]
                 [callback
                   (λ (button event)
                      (send dialog show #f)
                      (then restart?))]))])

      (final-action "Restart" #t)
      (final-action "Quit" #f)

      (send dialog show #t))))

(define (get-text-width dc text [font #f])
  (call-with-values
     (λ () (send dc get-text-extent text font))
     (λ (width height baseline padding) width)))

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

(define (game-container parent name [custom-draw #f] [initial-cards '()])
  (let*
    ([panel (new vertical-panel% [parent parent])]
     [name-label (new message% [parent panel] [label name])]
     [score-label
       (new message%
            [parent panel]
            [label ""]
            [auto-resize #t])]

     [current-cards (make-parameter initial-cards)]
     [card-canvas
       (new canvas%
            [parent panel]
            [style '(border transparent)]
            [paint-callback
              (λ (canvas dc)
                 ((or custom-draw draw-stack)
                  canvas dc (current-cards)))])]

     [container (list panel score-label card-canvas current-cards)])

    (when [not custom-draw] (update-score container 0))
    container))

(define container-panel car)
(define score-label cadr)
(define card-canvas caddr)
(define current-cards cadddr)

(define (initial-grab game deck container player-id)
  (cond [(ready? (get-player game player-id)) game]
        [else (initial-grab (grab game deck container player-id)
                            deck container player-id)]))

(define (grab game deck container player-id)
  (match (take-card game)
         [(cons card game)
          (let*
            ([game (put-card game player-id card)]
             [player (get-player game player-id)]

             [cards (shown-cards (reverse (held-cards player))
                                 container player-id)]

             [cards-in-deck (- 52 (length (taken-cards game)))])

            (flip 0.1
              (λ ()
                 (animate-deck-grab (card-canvas deck) cards-in-deck)

                 (update-cards deck cards-in-deck)
                 (update-cards container cards)
                 (update-score container (score player))))

            game)]))

(define (animate-deck-grab canvas remaining)
  (define (do-frame dc steps)
    (when [< steps 5]

      (send dc suspend-flush)
      (send dc erase)

      (draw-deck canvas dc remaining (* 0.1 (+ steps 1)))
      (send dc resume-flush)

      (sleep 0.025)
      (do-frame dc (+ steps 1))))

  (let ([dc (send canvas get-dc)])
    (do-frame dc 0)))

(define (shown-cards all-cards container player-id)
  (cond [(or (empty? all-cards)
             (not (eqv? player-id 'croupier))
             (send (container-panel container) is-enabled?))

         all-cards]

        [else (cons 'hidden (cdr all-cards))]))

(define (flip duration action)
  (play-sound (build-path assets-path "card-flip.wav") #t)
  (action)
  (sleep/yield duration))

(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))

(define (update-cards container cards)
  ((current-cards container) cards)
  (send (card-canvas container) refresh-now))

(define (draw-stack canvas dc cards)
  (letrec 
    ([spacing (λ (bitmap) (quotient (send bitmap get-width) 4))]
     [draw-stack
       (λ (offset cards)
          (when [not (empty? cards)]
            (let*
              ([bitmap (card-bitmap (car cards))]
               [scale (fitting-scale canvas bitmap)])

              (send dc set-scale scale scale)
              (send dc draw-bitmap bitmap offset 0)

              (draw-stack (+ offset (spacing bitmap)) (cdr cards)))))]

     #| We want a centered card stack, therefore:
     || base-offset = canvas-width/2 - stack-width/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-width))/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-spacing * 4))/2
     ||             = (real-canvas-width/scale - (n + 3) * card-spacing)/2
     |#
     [base-offset
       (when [not (empty? cards)]
         (/ (- (/ (send canvas get-width)
                  (fitting-scale canvas (card-bitmap (car cards))))

               (* (+ (length cards) 3)
                  (spacing (card-bitmap (car cards)))))
            2))])

    (draw-stack base-offset cards)))

(define (draw-deck canvas dc count [swipe-factor 0])
  (when [> count 0]
    (let* ([many-cards (card-bitmap 'large-stack)]
           [hidden (card-bitmap 'hidden)]

           [width (send many-cards get-width)]
           [height (send many-cards get-height)]
           ; Should be the same for 'hidden
           [scale (fitting-scale canvas many-cards)]

           [swipe-unit (send hidden get-width)]
           [spacing (round (/ swipe-unit 32))]
           [crop-width (* spacing (- count 1))]
           [joint (- width (* spacing 51))])

      (send dc set-scale scale scale)

      (send dc draw-bitmap-section many-cards 0 0 0 0 crop-width height)
      (send dc draw-bitmap-section many-cards
            crop-width 0 (- width joint) 0 joint height)

      (let
        ([draw-hidden
           (λ (displacement)
              (send dc draw-bitmap hidden (+ crop-width joint displacement) 0))])

        (draw-hidden 0)
        (when [not (zero? swipe-factor)]
          (draw-hidden (* swipe-factor swipe-unit)))))))

(define (fitting-scale canvas bitmap)
  (/ (send canvas get-height) (send bitmap get-height)))

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
  (read-bitmap (build-path assets-path (path-add-extension path ".png")) 'png))

(define loaded-bitmaps (make-hash))

(define (preload-bitmaps [gauge #f])
  (letrec
    ([special-bitmap
       (λ (key asset)
          (when [not (hash-has-key? loaded-bitmaps key)]
            (hash-set! loaded-bitmaps key (load-bitmap asset)))

          (progress gauge))]

     [preload-bitmaps
       (λ (cards)
          (when [not (empty? cards)]
            (yield)
            (card-bitmap (car cards))

            (progress gauge)
            (preload-bitmaps (cdr cards))))])

    (special-bitmap 'hidden "cards/red_back")
    (special-bitmap 'large-stack "cards/many")

    (preload-bitmaps (cartesian-product '(1 2 3 4 5 6 7 8 9 10 jack queen king 11)
                                        '(pikes hearts clovers diamonds)))))

(define (progress gauge)
  (when gauge
    (send gauge set-value (min (+ 1 (send gauge get-value)) (send gauge get-range)))))
