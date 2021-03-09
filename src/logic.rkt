#lang racket

#| Función [nombre funcion]
Descripción: 
Entradas: 
    - parametros
Salida: 
Ejemplos de uso:
    - codigo ->  resultado
|#

;----------------non implemented functions-----;
(define (bCEj X)#t)

(define (score player)#t)
(define (name player)#t)
(define (active? player)#t)
(define (players game)#t)
(define (croupier game)#t)
(define (game-finished? game)#t)
(define (take-card game)#t)
(define (put-card game player card)#t)
(define (new-game player-names)#t)
(define (next-turn game last-player)#t)
(define (hang game player)#t)



;------------------quicksort related------------;


;olista inicia en '(()()())
;(define (qs-classify ilist predicate pivot olista)
;    (define(first-element){car ilist})
;    (define(add-minor x){list (cons x (car olista)) (cadr olista) (caddr olista)})
;    (define(add-equal x){list (car olista) (cons x (cadr olista)) (caddr olista)})
;    (define(add-major x){list (car olista) (cadr olista) (cons x(caddr olista))})
;     {cond 
;        [{null? ilist} olista]
;        [{equal? pivot (first-element)}{qs-classify (cdr ilist) predicate pivot (add-equal (first-element))}]
;        [{predicate pivot (first-element)}{qs-classify (cdr ilist) predicate pivot (add-major (first-element))}]
;        [else {qs-classify (cdr ilist) predicate pivot (add-minor (first-element))}]
;    })

;-------------------implemented functions
(define (qs-minor ilist predicate pivot olist)
    {cond
        [{null? ilist} olist]
        [{and (not (predicate pivot (car ilist))) (not (= pivot (car ilist)))}{qs-minor (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-minor (cdr ilist) predicate pivot olist}]
    })
(define (qs-major ilist predicate pivot olist)
    {cond
        [{null? ilist} olist]
        [{predicate pivot (car ilist)}{qs-major (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-major (cdr ilist) predicate pivot olist}]
    })
(define (qs-equal ilist pivot olist)
    {cond
        [{null? ilist} olist]
        [{= pivot (car ilist)} {qs-equal (cdr ilist) pivot (cons (car ilist) olist)}]
        [else {qs-equal (cdr ilist) pivot olist}]
    })

(define (quicksort ilist predicate)
    (define (pivot){car ilist})
    (define (equal-list){qs-equal ilist (pivot) '()})
    (define (major-list){qs-major ilist predicate (pivot) '()})
    (define (minor-list){qs-minor ilist predicate (pivot) '()})
    {cond
        [{null? ilist}'()]
        [{null? (minor-list)}
            {cond
                [{null? (major-list)}{equal-list}]
                [else {append (equal-list) (quicksort (major-list) predicate)}]
            }]
        [else {append (quicksort (minor-list) predicate) (equal-list) (quicksort (major-list) predicate)}]
    })



(define (create-card value symbol){list value symbol})
(define (card-value card){car card})
(define (card-symbol card){cadr card})

(define (code-symbol code)
    {cond
        [{= code 0} 'hearts]
        [{= code 1} 'clovers]
        [{= code 2} 'diamonds]
        [else 'spades]
    })

(define (random-card)
    {create-card (+ 1 (random 13)) (code-symbol (random 4))})

(define (high-ace card)
    {cond
        [{= 1 (card-value card)}{create-card 11 (card-symbol card)}]
        [else card]
    })