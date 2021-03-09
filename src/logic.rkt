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

;game = (players, croupier,taken-cards)
;players  = (("Foo" #t 0) ("Bar" #t 0) ("Baz" #t 0))
;player = ("nombre" #t 0)
;croupier = '(croupier #t 0 ())

(define game(new-game (list "Foo" "Bar" "Baz")))


(define (game-finished? game)#t)
(define (take-card game)#t)
(define (put-card game player card)#t)
(define (hang game player)#t)
(define (next-turn game last-player)#t)



;-------------------implemented functions

;------------------quicksort related start------------;
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
;------------------quicksort related end------------;


(define (create-card value symbol)
    {cond
        [{< value 11}{list value symbol}]
        [else 
            {cond
                [{= value 11}{list 'jack symbol}]
                [{= value 12}{list 'queen symbol}]
                [else {list 'king symbol}]
            }]
    })

(define (card-value card){car card})
(define (card-symbol card){cadr card})

(define (code-symbol code)
    {cond
        [{= code 0} 'hearts]
        [{= code 1} 'clovers]
        [{= code 2} 'diamonds]
        [else 'pikes]
    })

(define (random-card)
    {create-card (+ 1 (random 13)) (code-symbol (random 4))})

(define (high-ace card)
    {cond
        [{= 1 (card-value card)}{create-card 11 (card-symbol card)}]
        [else card]
    })

(define (create-player name){list name #t '()})

(define (held-cards player){caddr player})

(define (score-aux cards score-sum)
    (define (first-card){caar cards})
    (define (remaining-cards){cdr cards})
    {cond
        [{null? cards}score-sum]
        [{integer? (first-card)}{score-aux (remaining-cards) (+ (first-card) score-sum)}]
        [{equal? (first-card) 'jack}{score-aux (remaining-cards) (+ 10 score-sum)}]
        [{equal? (first-card) 'queen}{score-aux (remaining-cards) (+ 10 score-sum)}]
        [{equal? (first-card) 'king}{score-aux (remaining-cards) (+ 10 score-sum)}]
})

(define (score player){score-aux (held-cards player) 0})

(define (name player){car player})

(define (active? player){cadr player})

(define (players game){car game})

(define (croupier game){cadr game})

(define (new-game-aux player-names player-list)
    {cond
        [{null? player-names}player-list]
        [else {new-game-aux 
                (cdr player-names)
                (cons (create-player (car player-names)) player-list)
        }]
    })

(define (new-game player-names)
    {list (new-game-aux player-names '()) (create-player 'croupier) '()})
