#lang racket/base

(require racket/gui)
(require "logic.rkt")

(provide bCEj)

(define (bCEj X)
  (cond [(not (integer? X)) (raise "Expected an integer numbe rof players")]
        [(or (< X 1) (> X 3)) (raise "There may only be one, two, or three players")])

  (let* ([names-dialog (new dialog% [label "Player nams"])])
    (new button% [parent names-dialog] [label "Play"])
    (send names-dialog show #t)))
