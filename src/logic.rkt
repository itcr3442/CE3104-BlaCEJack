#lang racket
#|______________________________________________________ 
Instituto Tecnológico de Costa Rica
Área Académica de Ingeniería en Computadores
Lenguajes, Compiladores e Intérpretes Grupo 02
Profesor: Marco Rivera Meneses
Estudiantes: José Fernando Morales Vargas - 2019024270
             Alejandro Jose Soto Chacón
_______________________________________________________|#


#| Notas generales
- un prefijo 'i' a un sustantivo significa que dicho parámetro es de entrada (input)
    e.g ilist
- un prefijo 'o' a un sustantivo significa que dicho parámetro es de salida (output)
    e.g. olist

Representacción de elementos de juego:
game = (players, croupier,taken-cards)
players  = (("Foo" 'flag (cards)) ("Bar" 'flag ()) ("Baz" 'flag ()))
player = ("nombre" 'flag (held-cards))
croupier = '(croupier 'flag (held-cards))
|#
;----------------non implemented functions-----;
(define (bCEj X)#t)
;-------------------implemented functions

#| Función list-get
Descripción: Obtiene el elemento de una lista ubicado en el índice dado.
Entradas: 
    - list: Lista de la cuál se extrae el elemento.
    - position: Índice en el cual se enceuntra el elemento que se busca.
Salida: Si la lista tiene un elemento dicho índice, retorna el elemento, de lo contrario emite un
        mensaje de error que indica que los parámetros son erróneos. 
Ejemplo de uso:
    - >(list-get '(1 2 3 4) 2) >>> 3
|#
(define (list-get list position)
    {cond
        [{null? list}{raise "list index out of bounds"}]
        [{= 0 position} {car list}]
        [else {list-get (cdr list) (- position 1)}]
    })

;------------------quicksort related start------------;

#| Función qs-minor
Descripción: Compara cada elemento de una lista contra un pivote utilizando la función
             parámetro de comparación "predicate". Los elementos que al ser comparados
             con el pivote den un resultado false serán agregados a una lista que se da 
             como resultado de la función al finalizar de procesar la lista de entrada
Entradas: 
    - ilist: Lista de entrada 
    - predicate: Es una función que toma dos elementos de la lista y determina si el primero 
                 se debe ordenar como menor que el segundo.
    - pivot: Elemento a compararse contra cada elemento de la lista dada 
    - olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote 
             usando la función "predicate" de como resultado #f. Debe ser inicializada en '()
             para uso de la función
Salida: Contenido final de olist al finalizar el recorrido por la lista de entrada
Ejemplos de uso:
    - >(qs-minor '(8 4 2 3 1 6 7) > 4 '()) >>> (7 6 8)
|#
(define (qs-minor ilist predicate pivot olist)
    {cond
        [{null? ilist} olist]
        [{and (not (predicate pivot (car ilist))) (not (eq? pivot (car ilist)))}{qs-minor (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-minor (cdr ilist) predicate pivot olist}]
    })
#| Función qs-minor
Descripción: Compara cada elemento de una lista contra un pivote utilizando la función
             parámetro de comparación "predicate". Los elementos que al ser comparados
             con el pivote den un resultado true serán agregados a una lista que se da 
             como resultado de la función al finalizar de procesar la lista de entrada
Entradas: 
    - ilist: Lista de entrada 
    - predicate: Es una función que toma dos elementos de la lista y determina si el primero 
                 se debe ordenar como menor que el segundo.
    - pivot: Elemento a compararse contra cada elemento de la lista dada 
    - olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote 
             usando la función "predicate" de como resultado #t. Debe ser inicializada en '()
             para uso de la función
Salida: Con
Ejemplos de uso:
    - >(qs-minor '(8 4 2 3 1 6 7) > 4 '()) >>> (7 6 8)
|#
(define (qs-major ilist predicate pivot olist)
    {cond
        [{null? ilist} olist]
        [{predicate pivot (car ilist)}{qs-major (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-major (cdr ilist) predicate pivot olist}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (qs-equal ilist pivot olist)
    {cond
        [{null? ilist} olist]
        [{eq? pivot (car ilist)} {qs-equal (cdr ilist) pivot (cons (car ilist) olist)}]
        [else {qs-equal (cdr ilist) pivot olist}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
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

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (create-card value symbol)
    {cond
        [{= value 1}{list 11 symbol}]
        [{< value 11}{list value symbol}]
        [else 
            {cond
                [{= value 11}{list 'jack symbol}]
                [{= value 12}{list 'queen symbol}]
                [else {list 'king symbol}]
            }]
    })

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (card-value card){car card})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (card-symbol card){cadr card})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (code-symbol code)
    {cond
        [{= code 0} 'hearts]
        [{= code 1} 'clovers]
        [{= code 2} 'diamonds]
        [else 'pikes]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (random-card)
    {create-card (+ 1 (random 13)) (code-symbol (random 4))})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (high-ace card)
    {cond
        [{= 1 (card-value card)}{create-card 11 (card-symbol card)}]
        [else card]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (taken-cards game){caddr game})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
( define(in-list? elemento lista)
    {cond
        [{null? lista} #f]
        [else {cond
            ((equal? elemento (car lista)) #t)
            (else (in-list? elemento (cdr lista)))
        }]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (add-taken-card game card)
    {list
        (players game)
        (croupier game)
        (cons card (taken-cards game))
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (take-card-aux game card)
    {cond 
        [{in-list? card (taken-cards game)}{take-card-aux game (random-card)}]
        [else {cons card (add-taken-card game card)}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (take-card game)
    {take-card-aux game (random-card)})


;--------------player related functions START
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (create-player name){list name 'active '()})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (name player){car player})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (player-state player){cadr player})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (held-cards player){caddr player})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (update-player-hand player new-hand)
    {list
        (name player)
        (player-state player)
        new-hand
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (active? player){eq? 'active (player-state player)})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (lost? player){eq? 'lost (player-state player)})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (hanged? player){eq? 'hanged (player-state player)})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (players game){car game})

#| Función
Descripción: 
Entradas: 
    - 
    - id: debe inicializarse en 0
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (active-players-aux players id list)
    {cond
        [{null? players}{reverse list}]
        [{active? (first players)}{active-players-aux (cdr players) (+ id 1) (cons (cons id (first players)) list)}]
        [else {active-players-aux (cdr players) (+ id 1) list}]
    })

#| Función
Descripción: 
Entradas: 
    - 
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (active-players game)
    {active-players-aux (players game) 0 '()})

#| Función
Descripción: 
Entradas: 
    - 
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (player-count game){length (players game)})

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (croupier game){cadr game})

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (accept-card player card)
    {list
        (name player)
        (player-state player)
        (cons card (held-cards player))
    })

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (set-lost player)
    {list 
        (name player) 
        'lost 
        (held-cards player)
    })

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
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

#| Función
Descripción: aplica una función modificador a cada jugador y 
             guarda los datos actualizados en una nueva lista
Entradas: 
    - predicate: es la operación 
    - id: debe inicializarse en 0
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (update-player predicate players index updated)
    {cond
        [{null? players}{reverse updated}]
        [{= 0 index}{update-player predicate (cdr players) -1 (cons (predicate (car players)) updated)}]
        [else {update-player predicate (cdr players) (- index 1) (cons (car players) updated)}]
    })

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
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

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (score player){score-aux (held-cards player) 0})

;----------------- player related functions END

;----------------- game state change functions START
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (hang game player)
    {cond
        [{eq? player 'croupier}
            {list 
                (players game)
                (set-hanged (croupier game))
                (taken-cards game)
            }]
        [{number? player}
            {cond
                [{or (> 0 player) (> player (- (player-count game) 1))}{raise "invalid player number"}]
                [else
                    {list
                        (update-player set-hanged (players game) player '())
                        (croupier game)
                        (taken-cards game)
                    }]
            }]
        [else {raise "invalid player identifier"}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (put-card game player card)
    (define(hand-card player){accept-card player card})
    {cond
        [{eq? player 'croupier}
            {list 
                (players game)
                (hand-card (croupier game))
                (taken-cards game)
            }]
        [{number? player}
            {cond
                [{or (> 0 player) (> player (- (player-count game) 1))}{raise "invalid player number"}]
                [else
                    {list
                        (update-player hand-card (players game) player '())
                        (croupier game)
                        (taken-cards game)
                    }]
            }]
        [else {raise "invalid player identifier"}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (next-turn-aux playing last-player)
    (define (look-for-active ilist predicate)
        {cond
            [{null? ilist} '()]
            [{predicate (caar ilist) last-player}{car ilist}]
            [else {look-for-active (cdr ilist) predicate}] 
        })
    {cond
        [{null? playing}'()]
        [{null? (look-for-active playing >)}
            {cond
                [{null? (look-for-active playing <)}{look-for-active playing =}]
                [else {look-for-active playing <}]
            }]
        [else {look-for-active playing >}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|# 
(define (next-turn game last-player)
    {cond
        [{active? (croupier game)}{next-turn-aux (active-players game) last-player}]
        [else '()]
    })


#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (has-aces list)
    {cond
        [{or 
            (in-list? '(11 hearts) list) (in-list? '(11 diamonds) list) 
            (in-list? '(11 pikes) list) (in-list? '(11 clovers) list)}#t]
        [else #f]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (change-one-ace ilist olist)
    {cond
        [{null? ilist}olist]
        [{eq? (caar ilist) 11} {append (cdr ilist) (cons (list 1 (cadar ilist)) olist)}]
        [else {change-one-ace (cdr ilist) (cons (car ilist) olist)}]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|# 
(define (try-changing-aces player)
    (define (new-player-state){update-player-hand player (change-one-ace (held-cards player) '())})
    {cond
        [{has-aces (held-cards player)}
            {cond
                [{> 21 (score (new-player-state))}{new-player-state}]
                [else {try-changing-aces (new-player-state)}]
            }]
        {else player} ; 
    })

;ejemplo de uso y test
;(define pepe(list "pepe" 'active '((5 pikes) (11 hearts) (11 diamonds) (11 clovers))))
;(try-changing-aces pepe)

;------------------- game state change functions END

#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (new-game-aux player-names player-list)
    {cond
        [{null? player-names}{reverse player-list}]
        [else {new-game-aux 
                (cdr player-names)
                (cons (create-player (car player-names)) player-list)
        }]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (new-game player-names)
    {list (new-game-aux player-names '()) (create-player 'croupier) '()})
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (game-finished?-aux players)
    {cond
        [{null? players} #f]
        [{active? (car players)}{game-finished?-aux (cdr players)}]
        [else #t]
    })
#| Función
Descripción: 
Entradas: 
    - 
    -
Salida: 
Ejemplos de uso:
    - >codigo >>> resultado
|#
(define (game-finished? game)
    {and (game-finished?-aux (players game)) (active? (croupier game))})


;''''''''''''''''''''''''''''''''''''''''''''''
;''''''''''''''''''''''''''''''''''''''''''''''
;'''''''''''''''''test-values'''''''''''''''''''
;''''''''''''''''''''''''''''''''''''''''''''''
;''''''''''''''''''''''''''''''''''''''''''''''

(define game(new-game (list "Foo" "Bar" "Baz")))
(define game2 '(((Foo active ((king hearts)(8 pikes)))
                 (Bar active ((queen clovers)(11 pikes)))
                 (Baz active ((11 diamonds))))(croupier)
                 ((king hearts)(8 pikes)(queen clovers)(11 pikes)(11 diamonds))))

(score '(Foo active ((king hearts)(8 pikes))))
(quicksort (players game2) (lambda (a b) (> (score a) (score b)))) 