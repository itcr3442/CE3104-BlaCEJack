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
                      (let ((game (put-card game player-id card)))
                        (update-score (list-get player-containers player-id)
                                      (score (list-get (players game) player-id)))

                        (rotate-player game player-id))])))

      (send current-player set-label (name player)))

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
  (let ([panel (new vertical-panel% [parent parent])])
    (new message% [parent panel] [label name])

    (let ([container (list (dynamic-label panel))])
      (update-score container 0)
      container)))

(define score-label car)

(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))
