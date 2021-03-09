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
(define (qs-classify ilist predicate)#t)
(define (quicksort list predicate)#t)

;-------------------implemented functions
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