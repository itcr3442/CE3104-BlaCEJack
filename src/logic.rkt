#lang racket

#| Función [nombre funcion]
Descripción: 
Entradas: 
    - parametros
Salida: 
Ejemplos de uso:
    - codigo ->  resultado
|#


;---notes 

;game = (players, croupier,taken-cards)
;players  = (("Foo" (playing? lost? hanged?) (cards)) ("Bar" #t ()) ("Baz" #t ()))
;player = ("nombre" (playing lost hanged) 0)
;croupier = '(croupier (playing? lost? hanged?) ())




;----------------non implemented functions-----;
(define (bCEj X)#t)



(define (put-card game player card)#t)

(define (next-turn game last-player)#t)

;-------------------implemented functions
(define (list-get list position)
    {cond
        [{null? list}{raise "list index out of bounds"}]
        [{= 0 position} {car list}]
        [else {list-get (cdr list) (- position 1)}]
    })
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

(define (taken-cards game){caddr game})

( define(in-list? elemento lista)
    {cond
        [{null? lista} #f]
        [else {cond
            ((equal? elemento (car lista)) #t)
            (else (in-list? elemento (cdr lista)))
        }]
    })

(define (add-taken-card game card)
    {list
        (players game)
        (croupier game)
        (cons card (taken-cards game))
    })

(define (take-card-aux game card)
    {cond 
        [{in-list? card (taken-cards game)}{take-card-aux game (random-card)}]
        [else {cons card (add-taken-card game card)}]
    })

(define (take-card game)
    {take-card-aux game (random-card)})


;--------------player related functions START

(define (create-player name){list name 'active '()})

(define (name player){car player})

(define (player-state player){cadr player})

(define (held-cards player){caddr player})

(define (active? player){eq? 'active (player-state player)})

(define (lost? player){eq? 'lost (player-state player)})

(define (hanged? player){eq? 'hanged (player-state player)})

(define (players game){car game})

(define (croupier game){cadr game})

(define (set-lost player)
    {list 
        (name player) 
        'lost 
        (held-cards player)
    })

(define (set-hanged player)
    {list 
        (name player) 
        'hanged 
        (held-cards player)
    })


; esto aplica una modificacion cualquier a un player
; index valores de 0 a 2 
; updated inicializado en '()
; devuleve toda la listya de players 
(define (update-player predicate players index updated)
    {cond
        [{null? players}{reverse updated}]
        [{= 0 index}{update-player predicate (cdr players) -1 (cons (predicate (car players)) updated)}]
        [else {update-player predicate (cdr players) (- index 1) (cons (car players) updated)}]
    })


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



;----------------- player related functions END

;----------------- game state change functions START

(define (hang game player)
    {cond
        [{> player (length (players game))}{game}]
        [{= player (length (players game))}
            {list 
                (players game)
                (set-hanged (croupier game))
                (taken-cards game)
            }]
        [else
            {list
                (update-player set-hanged (players game) player '())
                (croupier game)
                (taken-cards game)
        }]
    })
;------------------- game state change functions END


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



(define (game-finished?-aux players)
    {cond
        [{null? players} #f]
        [{active? (car players)}{game-finished?-aux (cdr players)}]
        [else #t]
    })

(define (game-finished? game)
    {and (game-finished?-aux (players game)) (active? (croupier game))})

(define game(new-game (list "Foo" "Bar" "Baz")))
(take-card game)