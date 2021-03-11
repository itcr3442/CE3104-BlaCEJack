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
                               (raise "To do")])))])

    (send names-dialog show #t)))

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
