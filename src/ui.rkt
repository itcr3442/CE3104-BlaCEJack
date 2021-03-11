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

     [current-player (dynamic-label bottom-row)])

    (new button%
         [parent bottom-row]
         [label "Take card"])

    (new button%
         [parent bottom-row]
         [label "Hang up"])

    (send window show #t)))

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
