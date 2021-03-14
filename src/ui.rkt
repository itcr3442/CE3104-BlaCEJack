#lang racket/base

(require racket/gui)
(require "logic.rkt")

(provide bCEj run-game)

(define (bCEj X)
  (cond [(not (integer? X)) (raise "Expected an integer numbe rof players")]
        [(or (< X 1) (> X 3)) (raise "There may only be one, two, or three players")])

  (let*
    ([names-dialog (new dialog% [label "Player nams"])]
     [name-fields (add-name-fields names-dialog X 1 empty)])

    (new button%
         [parent names-dialog]
         [label "Play"]
         [callback (λ (button event)
                     (let ([player-names
                             (map (λ (field) (string-trim (send field get-value)))
                                  name-fields)])

                       (cond [(empty? (filter (compose not non-empty-string?) player-names))
                              (send names-dialog show #f)
                              (run-game player-names)])))])

    (send names-dialog show #t)))

(define (run-game player-names)
  (let*
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

     [on-hang-up (make-parameter #f)]
     [on-take-card (make-parameter 0)])

    (define (do-turn game player-id player)
      (on-hang-up (λ () (rotate-player (hang game player-id) player-id)))
      (on-take-card
        (λ () (rotate-player
                 (grab game (list-get player-containers player-id) player-id)
                 player-id)))

      (send current-player set-label (name player)))

    (define (rotate-player game player-id)
        (cond [(not (active? (get-player game player-id)))
             (send (container-panel (list-get player-containers player-id)) enable #f)])

      (match (next-turn game player-id)
             [(list) ; No active player remains

              (send bottom-row show #f)
              (end-of-game game croupier-container)]

             [(cons next-id next) (do-turn game next-id next)]))

    (new button%
         [parent bottom-row]
         [label "Take card"]
         [callback (λ (button event) ((on-take-card)))])

    (new button%
         [parent bottom-row]
         [label "Hang up"]
         [callback (λ (button event) ((on-hang-up)))])

    (send (container-panel croupier-container) enable #f)
    (send (score-label croupier-container) show #f)

    (send bottom-row show #f)
    (send window show #t)
    (sleep/yield 0.5)

    (define (initial-grab-for-players game containers player-ids)
      (cond [(empty? player-ids) game]
            [else (initial-grab-for-players
                    (initial-grab game (car containers) (car player-ids))
                    (cdr containers) (cdr player-ids))]))

    (let* ([game (new-game player-names)]
           [game (initial-grab game croupier-container 'croupier)]
           [game (initial-grab-for-players
                   game player-containers (range (length (players game))))])

      (do-turn game 0 (car (players game))))

    (send bottom-row show #t)))

(define (end-of-game game croupier-container)
  (define (grab-last-croupier-cards game)
    (cond [(not (game-finished? game))
           (grab-last-croupier-cards (grab game croupier-container 'croupier))]))

  (send (container-panel croupier-container) enable #t)
  (send (container-panel croupier-container) refresh)
  (send (score-label croupier-container) show #t)

  (grab-last-croupier-cards game))

(define (add-name-fields dialog up-to next fields)
  (cond [(> next up-to) (reverse fields)]
        [else (add-name-fields
                dialog
                up-to
                (+ next 1)
                (cons (new text-field%
                           [parent dialog]
                           [label
                             (string-append "Player #"
                                            (number->string next))]) fields))]))

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

            (update-cards container cards)
            (update-score container (score player))

            game)]))

(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))

(define (update-cards container cards)
  ((current-cards container) cards)

  (play-sound "../assets/card-flip.wav" #t)
  (send (card-canvas container) refresh-now)
  (sleep/yield 0.3))

(define (redraw-cards canvas dc cards)
  (define (redraw-cards offset cards)
    (cond [(not (empty? cards))

           (let*
             ([bitmap (card-bitmap (car cards))]
              [scale (/ (send canvas get-height) (send bitmap get-height))])

             (send dc set-scale scale scale)
             (send dc draw-bitmap bitmap offset 0)

             (redraw-cards (+ offset (/ (send bitmap get-width) 4)) (cdr cards)))]))

  (redraw-cards 0 cards))

(define (card-bitmap card)
  (cond [(hash-has-key? loaded-bitmaps card) (hash-ref loaded-bitmaps card)]
        [else (let*
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
(hash-set! loaded-bitmaps 'hidden (load-bitmap "cards/red_back"))

; Preload images
(for-each card-bitmap (cartesian-product '(1 2 3 4 5 6 7 8 9 10 jack queen king 11)
                                         '(pikes hearts clovers diamonds)))
