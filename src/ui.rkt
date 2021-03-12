#lang racket/base

(require racket/gui)
(require "logic.rkt")

(provide bCEj)

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
                              (run-game player-names)
                              (send names-dialog show #f)])))])

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

     [on-take-card (make-parameter #f)]
     [on-hang-up (make-parameter #f)])

    (new button%
         [parent bottom-row]
         [label "Take card"]
         [callback (λ (button event) ((on-take-card)))])

    (new button%
         [parent bottom-row]
         [label "Hang up"]
         [callback (λ (button event) ((on-hang-up)))])

    (define (rotate-player game player-id)
      (match (next-turn game player-id)
             [(list) (raise "Not implemented")]
             [(cons next-id next) (turn game next-id next)]))

    (define (turn game player-id player)
      (on-hang-up (λ () (rotate-player (hang game player-id) player-id)))
      (on-take-card
        (λ () (match (take-card game)
                     [(cons card game)
                      (let*
                        ([game (put-card game player-id card)]
                         [container (list-get player-containers player-id)]
                         [player (list-get (players game) player-id)])

                        (update-cards container (reverse (held-cards player)))
                        (update-score container (score player))

                        (rotate-player game player-id))])))

      (send current-player set-label (name player)))

    (send (score-label croupier-container) show #f)
    (send window show #t)

    (let ([initial-game (new-game player-names)])
      (turn initial-game 0 (car (players initial-game))))))

;TODO: Delete this during module integration
(define (next-turn game player-id)
  (let ([next-id (remainder (+ player-id 1) (length (players game)))])
    (cons next-id (list-get (players game) next-id))))

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
                            (redraw-cards canvas dc (current-cards) 0))])]

     [container (list score-label card-canvas current-cards)])

    (update-score container 0)
    container))

(define score-label car)
(define card-canvas cadr)
(define current-cards caddr)

(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))

(define (update-cards container cards)
  ((current-cards container) cards)
  (send (card-canvas container) refresh))

(define (redraw-cards canvas dc cards offset)
  (cond [(not (empty? cards))

         (let*
           ([bitmap (card-bitmap (car cards))]
            [scale (/ (send canvas get-height) (send bitmap get-height))])

           (send dc set-scale scale scale)
           (send dc draw-bitmap bitmap offset 0)

           (redraw-cards canvas dc (cdr cards)
                         (+ offset (/ (send bitmap get-width) 4))))]))

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
