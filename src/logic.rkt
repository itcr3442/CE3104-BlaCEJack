#lang racket/base
#|______________________________________________________ 
Instituto Tecnológico de Costa Rica
Área Académica de Ingeniería en Computadores
Lenguajes, Compiladores e Intérpretes Grupo 02
Profesor: Marco Rivera Meneses
Estudiantes: José Fernando Morales Vargas - 2019024270
             Alejandro José Soto Chacón - 2019008164
_______________________________________________________|#

(provide list-get score name active? lost? has-stood? ready? players
         get-player croupier game-finished? take-card put-card new-game
         next-turn stand held-cards card-value card-symbol taken-cards
         quicksort scoreboard)

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
        [{and (not (predicate pivot (car ilist))) (not (eq? pivot (car ilist)))}
            {qs-minor (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-minor (cdr ilist) predicate pivot olist}]
    })

#| Función qs-major
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
Salida: Contenido final de olist al finalizar el recorrido por la lista de entrada
Ejemplos de uso:
    - >(qs-major '(8 4 2 3 1 6 7) > 4 '()) >>> (1 3 2)
|#

(define (qs-major ilist predicate pivot olist)
    {cond
        [{null? ilist} olist]
        [{predicate pivot (car ilist)}
            {qs-major (cdr ilist) predicate pivot (cons (car ilist) olist)}]
        [else {qs-major (cdr ilist) predicate pivot olist}]
    })

#| Función qs-equal
Descripción: Compara cada elemento de una lista contra un pivote para verificar si sus
             valores son iguales. Los elementos que al ser comparados
             con el pivote den un resultado true serán agregados a una lista que se da 
             como resultado de la función al finalizar de procesar la lista de entrada
Entradas: 
    - ilist: Lista de entrada 
    - pivot: Elemento a compararse contra cada elemento de la lista dada 
    - olist: Lista en la que se guardan aquellos elementos de igual valor que el pivote 
             Debe ser inicializada en '() para uso de la función
Salida: Contenido final de olist al finalizar el recorrido por la lista de entrada
Ejemplos de uso:
    - >(qs-equal '(2 8 4 2 3 4 5 4 1 6 7 4) > 4 '()) >>> (4 4 4 4)
|#

(define (qs-equal ilist pivot olist)
    {cond
        [{null? ilist} olist]
        [{eq? pivot (car ilist)}
            {qs-equal (cdr ilist) pivot (cons (car ilist) olist)}]
        [else {qs-equal (cdr ilist) pivot olist}]
    })


#| Función
Descripción: Ordena una lista dada utilizando una implementación de quicksort
Entradas: 
    - ilist: Lista a ordenar usando quicksort
    - predicate: Función que toma dos elementos y determina si el primero se debe 
                 ordenar como menor que el segundo.
Salida: Lista de entrada ordenada
Ejemplos de uso:
    - >(quicksort '(2 3 4 1 1 2 5) <) 
        >>> '(1 1 2 2 3 4 5)
    - >(quicksort '(2 3 4 1 1 2 5) >) 
        >>> '(5 4 3 2 2 1 1)
    - >(define game ...) (quicksort (players game) (lambda (a b) (> (score a) (score b))))
        >>> '(("Bar" #f 21) ("Foo" #f 18) ("Baz" #f 11))
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

#| Función create-card
Descripción: Crea un par que representa una carta a partir de un valor numérico y
             un símbolo dados
Entradas: 
    - value: Orden de la carta en un conjunto de cartas de un símbolo
    - symbol: símbolo del conjunto de cartas a la que pertenece la carta a crear
Salida: Un par (valor símbolo) que representa una carta. De tener el parámetro value
        un valor de 11,12 o 13, en la posición respectiva al valor de la carta se 
        cambiará el valor por 'jack, 'queen y 'king respectivamente.
Ejemplos de uso:
    - >(create-card 2 'hearts) >>> '(2 hearts)
    - >(create-card 11 'pikes) >>> '(jack pikes)
|#

(define (create-card value symbol)
    {cond
        [{= value 1}{list 11 symbol}]
        [{< value 11}{list value symbol}]
        [else 
            {cond
                [{= value 11}{list 'jack symbol}]
                [{= value 12}{list 'queen symbol}]
                [{= value 13}{list 'king symbol}]
                [else {raise "invalid card value"}]
            }]
    })


#| Función
Descripción: Dado un par que representa una carta, obtiene el primer elemento
             el cual representa su valor
Entradas: 
    - card: carta cuyo valor se quiere conocer
Salida: valor de la carta
Ejemplos de uso:
    - >(card-value '(queen diamonds)) >>> 'queen
|#

(define (card-value card){car card})


#| Función card-symbol
Descripción: Dado un par que representa una carta, obtiene el segundo elemento
             el cual representa su símbolo
Entradas: 
    - card - carta de la cual se quiere extraer el símbolo
Salida: Símbolo de la carta dada
Ejemplos de uso:
    - >(card-symbol '(queen diamonds)) >>> 'diamons
|#

(define (card-symbol card){cadr card})


#| Función code-symbol
Descripción: Identifica un símbolo de carta basado en un valor numérico
            (usado para generación aleatoria de cartas)
Entradas: 
    - code: número que representa uno de los símbolos de un mazo de cartas
Salida: Valor de símbolo correspondiente al número dado
Ejemplos de uso:
    - >(code-symbol 2) >>> 'diamonds
|#

(define (code-symbol code)
    {cond
        [{= code 0} 'hearts]
        [{= code 1} 'clovers]
        [{= code 2} 'diamonds]
        [else 'pikes]
    })


#| Función random-card
Descripción: Genera un par que representa una carta de un mazo de manera aleatoria
Salida: Par carta generada de forma aleatoria
Ejemplos de uso:
    - >(random-card) >>> '(10 pikes)
|#

(define (random-card)
    {create-card (+ 1 (random 13)) (code-symbol (random 4))})


#| Función taken-cards 
Descripción: Obtiene la lista de cartas que han sido tomadas del mazo y se enceuntran
             en juego
Entradas: 
    - game: Estado de juego del cual se quieren saber las cartas usadas
Salida: Lista de cartas en juego de la partida dada
Ejemplos de uso:
    - >(define game ...)(taken-cards game) >>> '((1 hearts)(5 diamonds)(11 pikes))
|#

(define (taken-cards game){caddr game})


#| Función in-list?
Descripción: Verifica si un elemento dado se encuentra dentro de una lista 
Entradas: 
    - element: valor a buscar en la lista
    - ilist: lista en la que se buscará element
Salida: Valor booleano que indica si el elemento dado efectivamente es miembro de la
        lista dada
Ejemplos de uso:
    - >(in-list? 3 '(2 3 5)) >>> #t
    - >(in-list? 3 '(2 4 5)) >>> #f

|#

( define(in-list? element ilist)
    {cond
        [{null? ilist} #f]
        [else {cond
            ((equal? element (car ilist)) #t)
            (else (in-list? element (cdr ilist)))
        }]
    })


#| Función add-taken-card
Descripción: Agrega una carta a la lista de cartas en uso de un juego
Entradas: 
    - game: Juego cuya lista de cartas tomadas será modificada
    - card: Carta a agregar a la lista de cartas tomadas de "game"
Salida: Estado resultante de "game" al agregar la carta "card"
Ejemplos de uso:
    - >(define game ...) (add-taken-card game (3 clovers)) 
        >>> '(((Foo...)(Bar...)(Baz...))(croupier...)((3 clovers)...))
|#

(define (add-taken-card game card)
    {list
        (players game)
        (croupier game)
        (cons card (taken-cards game))
    })


#| Función take-card-aux
Descripción: Ayuda a la función take-card a agregar la carta dada al estado de juego
             a ser devuelto
Entradas: 
    - game: Juego al que se quiere agregar una carta tomada
    - card: Carta que se quiere registrar como tomada
Salida: Un par que tiene de primer elemento la carta tomada, y de segundo elemento el
        nuevo estado de juego de "game" en el que "card" se encuentra en la lista decartas
        tomadas.
Ejemplos de uso:
    - >(take-card-aux game '(6 clovers)) 
        >>> '((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
|#

(define (take-card-aux game card)
    {cond 
        [{in-list? card (taken-cards game)}{take-card-aux game (random-card)}]
        [else {cons card (add-taken-card game card)}]
    })


#| Función take-card
Descripción: Dado un estado de juego, agrega una carta a la lista de cartas tomadas y
             comunica la carta tomada junto con el nuevo estado de juego
Entradas: 
    - game: Juego al cual se quiere agregar una carta en uso
Salida: Par que contiene la carta tomada y el nuevo estado de juego que lista dicha carta
        como usada
Ejemplos de uso:
    - >(take-card game) 
        >>> '((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
|#

(define (take-card game)
    {take-card-aux game (random-card)})


;--------------player related functions START
#| Función create-player
Descripción: crea una lista que representa el estado de un jugador a partir de un nombre
             dado
Entradas: 
    - name: nombre para el jugador a ser generado 
Salida: lista que representa el estado de un jugador con el nombre provisto
Ejemplos de uso:
    - >(create-player "Foo") >>> '("Foo" active ())
|#

(define (create-player name){list name 'active '()})


#| Función name 
Descripción: Dado un par que representa un jugador, retorna el nombre del mismo
Entradas: 
    - player: lista que representa al jugador del cual se quiere obtener el nombre del jugador
Salida: Nombre del jugador correspondiente al estado de jugador dado
Ejemplos de uso:
    - >(name '("Foo" active ((3 clovers)(5 diamonds)))) >>> "Foo"
|#

(define (name player){car player})


#| Función player-state
Descripción: Dado un par que representa un jugador, retorna el estado 
             (active, stood, lost) del mismo
Entradas: 
    - player: lista que representa al jugador del cual se quiere saber el estado
Salida: Retorna si el jugador tiene como estado active,stood o lost
Ejemplos de uso:
    - >(player-state '("Foo" active ((3 clovers)(5 diamonds)))) >>> 'active
|# 

(define (player-state player){cadr player})


#| Función held-cards
Descripción: Dado un par que representa un jugador, retorna la lista de cartas en
             posesión de dicho jugador, en de pila (última tomada va primero).
Entradas: 
    - player: lista que representa al jugador del cual se quiere saber su lista de
              cartas
Salida: Lista de cartas en posesión del jugador
Ejemplos de uso:
    - >(held-cards '("Foo" active ((3 clovers)(5 diamonds)))) >>> '((3 clovers)(5 diamonds))
|#

(define (held-cards player){caddr player})


#| Función update-player-hand
Descripción: Reemplaza la mano del un jugador por una nueva mano representada como
             una lista de cartas
Entradas: 
    - player: Jugador cuya mano se quiere cambiar
    - new-hand: Nueva lista de cartas para el jugador 
Salida: Estado del jugador luego de cambiar su mano
Ejemplos de uso:
    - >(update-player-hand '("Foo" active ()) '((11 clovers)(3 pikes)))
        >>> '("Foo" active ((11 clovers)(3 pikes)))
|#

(define (update-player-hand player new-hand)
    {list
        (name player)
        (player-state player)
        new-hand
    })


#| Función active?
Descripción: Dado un jugador, retorna si el mismo se encuentra activo o no
Entradas: 
    -  player: jugador del cual se quiere saber si se encuentra activo
Salida: #t si el jugador está activo, #f de lo contrario
Ejemplos de uso:
    - >(active? ("Foo" active '())) >>> #t
    - >(active? '("Bar" stood '())) >>> #f
|#

(define (active? player){eq? 'active (player-state player)})


#| Función lost?
Descripción: Dado un jugador, retorna si el mismo ya perdió
Entradas: 
    -  player: jugador del cual se quiere saber si perdió
Salida: #t si el jugador perdió, #f de lo contrario
Ejemplos de uso:
    - >(lost? ("Foo" lost '())) >>> #t
    - >(lost? '("Bar" active '())) >>> #f
|#

(define (lost? player){eq? 'lost (player-state player)})


#| Función has-stood?
Descripción: Dado un jugador, retorna si el mismo se encuentra plantado o no
Entradas: 
    -  player: jugador del cual se quiere saber si se encuentra plantado
Salida: #t si el jugador está plantado, #f de lo contrario
Ejemplos de uso:
    - >(has-stood? ("Foo" stood '())) >>> #t
    - >(has-stood? '("Bar" active '())) >>> #f
|#

(define (has-stood? player){eq? 'stood (player-state player)})

#| Función ready?
Descripción: Determina si un participante ha tomado suficientes cartas para iniciar
Entradas: 
    - player: jugador del cual se quiere saber si ha tomado suficientes cartas
Salida: #t si el jugador ha tomado al menos dos cartas, #f de lo contrario
Ejemplos de uso:
    - >(ready? '("Foo" active '())) >>> #f
    - >(ready? '("Foo" active '((4 clovers) (3 hearts)))) >>> #t
|#
(define (ready? player)
    {>= (length (held-cards player)) 2})

#| Función players
Descripción: Obtiene la lista de jugadores de un estado de juego dado
Entradas: 
    - game: Estado de juego del cual se quiere obtener la lista de jugadores
Salida: Lista de jugadores del estado de juego "game"
Ejemplos de uso:
    - >(define game ...)(players game) >>> '(("Foo"...)("Bar"...)("Baz"...))
|#
(define (players game){car game})

#| Función get-player
Descripción: Conveniencia para obtener sea un jugador o el croupier
Entradas: 
    - game: Estado de juego del cual se quiere obtener un jugador
    - id: 'croupier, o un identificador de jugador válido
Salida: Participante según identificador
Ejemplos de uso:
    - >(define game ...)(get-player game 1) >>> '("Foo" stood (...))
    - >(get-player game 'croupier) >> '(croupier active (...))
|#

(define (get-player game id)
  {cond [{eq? id 'croupier} (croupier game)]
        [else {list-get (players game) id}]})

#| Función active-players-aux
Descripción: Recorre una lista de jugadores y crea otra lista con los jugadores
             activos de la primera, asegurándose de que el identificador asignado
             sea congruente con la posición del jugador en el juego
Entradas: 
    - players: lista de jugadores a ser recorrida
    - id: debe inicializarse en 0
    - olist: Deber ser inicializada en '(). En esta lista se van agragando todos
             los jugadores activos de una partida
Salida: Lista de jugadores activos con sus respectivos identificadores como primer elemento
Ejemplos de uso:
    - >(active-players-aux '(("Foo" active ())("Bar" stood (king clovers))("Baz" active ())) 0 '()) 
        >>> '((0 "Foo" active ())(2 "Baz" active ()))
|#

(define (active-players-aux players id olist)
    {cond
        [{null? players}{reverse olist}]
        [{active? (car players)}{active-players-aux (cdr players) (+ id 1) (cons (cons id (car players)) olist)}]
        [else {active-players-aux (cdr players) (+ id 1) olist}]
    })


#| Función
Descripción: Obtiene la lista de jugadores activos de una partida junto con su número
             de turno identificador.
Entradas: 
    - game: Juego del que se quieren obtener los jugadores activos
Salida: lista de jugadores activos de la partida "game"
Ejemplos de uso:
    - >(define game (new-game '("Foo" "Baz")))(active-players game) 
        >>> '((0 "Foo" active ())(1 "Baz" active ()))
|#

(define (active-players game)
    {active-players-aux (players game) 0 '()})


#| Función player-count
Descripción: Retorna la cantidad de jugadores en el juego
Entradas: 
    - game: Juego cuya cantidad de jugadores quiere conocerse
Salida: cantidad de jugadores en "game"
Ejemplos de uso:
    - >(define game (new-game '("Foo" "Baz")))(player-count game)
        >>> 2
|#

(define (player-count game){length (players game)})


#| Función croupier
Descripción: Obtiene la lista que representa el estado del croupier
Entradas: 
    - game: Juego del cual se quiere obtener el estado del croupier
Salida: Lista que representa estado del croupier
Ejemplos de uso:
    - >(define game (new-game '("Foo" "Baz")))(croupier game)
        >>> '(croupier active ())
|#

(define (croupier game){cadr game})


#| Función accept-card 
Descripción: Agrega una nueva carta a la mano de un jugador
Entradas: 
    - player: lista de estado del jugador al que se le quiere agregar una carta
              en su mazo
    - card: Carta a agregar al mazo del jugador
Salida: Nuevo estado de jugador ahora con la carta dada incluída en su mano
Ejemplos de uso:
    - >(accept-card '("Foo" active ()) '(5 clovers)) >>> '("Foo" active ((5 clovers)))
|#

(define (accept-card player card)
    {maybe-stand-croupier
        (maybe-lost
            (try-changing-aces (list (name player) (player-state player)
                                     (cons card (held-cards player)))))
    })


#| Función maybe-stand-croupier
Descripción: Si el jugador indicado es el croupier, se encuentra activo
             y además su puntuación es al menos 17, provoca que se plante,
             finalizando el juego. De lo contrario, retorna su entrada.
Entradas: 
    - player: Jugador que posiblemente es el croupier en estado final
Salida: Lista de nuevo estado de jugador
Ejemplos de uso:
    - >(maybe-stand-croupier '(croupier active ((11 hearts) (9 pikes))))
      >>> '(croupier stood (...))
|#

(define (maybe-stand-croupier player)
    {cond [{and (eq? (name player) 'croupier)
                (active? player)
                (>= (score player) 17)}
           {list 'croupier 'stood (held-cards player)}]

          [else player]
    })


#| Función maybe-lost
Descripción: Modifica una lista de estado de jugador para representar que el mismo
             ha perdido en caso de que su puntuación exceda 21
Entradas: 
    - player: Jugador que puede haber perdido
Salida: Lista de nuevo estado de jugador
Ejemplos de uso:
    - >(maybe-lost '("Foo" active ())) >>> '("Foo" active ())
    - >(maybe-lost '("Foo" active ((10 jack) (10 jack) (10 jack)))) >>> '("Foo" lost (...))
|#

(define (maybe-lost player)
    {cond [{> (raw-score player) 21}{list (name player) 'lost (held-cards player)}]
          [else player]})


#| Función set-stood
Descripción: Modifica una lista de estado de jugador para representar que el mismo
             se encuentra plantado
Entradas: 
    - player: Jugador que se quiere indicar que se plantó
Salida: Lista de nuevo estado de jugador
Ejemplos de uso:
    - >(set-stood '("Foo" active ())) >>> '("Foo" stood ())
|#

(define (set-stood player)
    {list 
        (name player) 
        'stood 
        (held-cards player)
    })


; index valores de 0 a 2 
; updated inicializado en '()
; devuleve toda la listya de players 

#| Función update-player
Descripción: Aplica una función modificador a un jugador de una lista identificado
             por un índice. Obtiene la nueva lista de jugadores con el jugador
             del índice especificado con su estado actualizado
Entradas: 
    - predicate: es la operación modificadora a aplicar a cada jugador 
    - index: índice de la lista en el que se encuentra el jugador. Empieza
             desde 0 y en un juego de 3 el máximo es 2
    - updated: Debe inicializarse en '(). Almacena la lista de jugadores ya procesados
Salida: Lista de jugadores con el estado del jugador especificado actualizada
Ejemplos de uso:
    - >(define game (new-game '("Foo" "Bar")))(update-player set-stood (players game) 0 '()) 
        >>> '(("Foo" stood ()) ("Bar" active ()))
|#

(define (update-player predicate players index updated)
    {cond
        [{null? players}{reverse updated}]
        [{= 0 index}{update-player predicate (cdr players) -1 (cons (predicate (car players)) updated)}]
        [else {update-player predicate (cdr players) (- index 1) (cons (car players) updated)}]
    })


#| Función score-aux
Descripción: Basada en la lista de cartas, retorna el puntaje que suman sus cartas. 
             Se encarga de descifrar el puntaje que agregan las cartas de valor no 
             numérico. Nótese que no es posible exceder una puntuación de 21, por
             lo que al perder el juego la última carta no altera la puntuación.
Entradas: 
    - cards: Lista de cartas cuyo puntaje quiere sumarse
    - previous-sum: suma de puntaje justo antes de sumada la última carta
                    en el valor contenido en `score-sum`
    - score-sum: valor numérico que contiene el puntaje que se suma conforme se
                 recorre la lista de cartas. Debe inicializarse en 0 
    - limit-to-21?: indica si deben ignorarse cartas que provoquen que
                    el puntaje se sobrepase de 21 o no
Salida: Puntaje que suma la lista de cartas dada
Ejemplos de uso:
    - >(score-aux '((3 clovers)(5 diamonds)) 0 0) >>> 8
|#

(define (score-aux cards previous-sum score-sum limit-to-21?)
    (define (first-card){caar cards})
    (define (remaining-cards){cdr cards})
    (define (card-worth)
        {cond
            [{integer? (first-card)}{first-card}]
            [{equal? (first-card) 'jack} 10]
            [{equal? (first-card) 'queen} 10]
            [{equal? (first-card) 'king} 10]
        })

    {cond
        [{and limit-to-21? (> score-sum 21)} previous-sum]
        [{null? cards} score-sum]
        [else {score-aux (remaining-cards) score-sum (+ score-sum (card-worth)) limit-to-21?}]
    })


#| Función score
Descripción: Toma una lista de estado de un jugador y calcula el puntaje que suman
             las cartas en su mano
Entradas: 
    - player: jugador cuyo puntaje se quiere obtener
Salida: Puntaje que suman las cartas en posesión del jugador
Ejemplos de uso:
    - >(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds)))) >>> 12
|#

(define (score player){score-aux (reverse (held-cards player)) 0 0 #t})


#| Función raw-score
Descripción: Equivalente a `score`, pero no ignora cartas que exceden
             el puntaje más allá 21
Entradas: 
    - player: jugador cuyo puntaje se quiere obtener
Salida: Puntaje que suman las cartas en posesión del jugador
Ejemplos de uso:
    - >(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds)))) >>> 12
|#

(define (raw-score player){score-aux (reverse (held-cards player)) 0 0 #f})

;----------------- player related functions END
;----------------- game state change functions START

#| Función stand
Descripción: Indica que el participante player, expresado como un entero correspondiente
             a un jugador o el átomo 'croupier, se ha plantado. Retorna el nuevo estado 
             de juego.
Entradas: 
    - game: Juego al que pertenece el jugador que quiere indicarse como plantado
    - player: identificador del jugador (croupier inclusive) a ser indicado
              como plantado
Salida: Nuevo estado de juego con lista de jugadores actualizada para mostrar
        el cambio en el estado del jugador plantado
Ejemplos de uso:
      >(define game(new-game '("Foo" "Bar" "Baz")))
    - >(stand game 0) 
        >>>'((("Foo" stood ()) ("Bar" active ()) ("Baz" active ()))(croupier active ())())
    - >(stand game 1)
        >>>'((("Foo" active ()) ("Bar" stood ()) ("Baz" active ()))(croupier active ())())
    - >(stand game 2)
        >>>'((("Foo" active ()) ("Bar" active ()) ("Baz" stood ()))(croupier active ())())
    - >(stand game 'croupier)
        >>>'((("Foo" active ()) ("Bar" active ()) ("Baz" active ()))(croupier stood ())())
|#

(define (stand game player)
    {cond
        [{eq? player 'croupier}
            {list 
                (players game)
                (set-stood (croupier game))
                (taken-cards game)
            }]
        [{number? player}
            {cond
                [{or (> 0 player) (> player (- (player-count game) 1))}{raise "invalid player number"}]
                [else
                    {list
                        (update-player set-stood (players game) player '())
                        (croupier game)
                        (taken-cards game)
                    }]
            }]
        [else {raise "invalid player identifier"}]
    })


#| Función put-card
Descripción: Agrega una carta al mazo de un jugador que se encuentra activo en una
             partida. No agrega la carta a la lista de cartas tomadas de juego, puesto
             que durante la generación de la carta dicha tarea ya se lleva a cabo
Entradas: 
    - game: Juego en que se encuentra el jugador al que se le quiere agregar una carta 
    - player: Es un entero que identifica a un jugador por orden, o el átomo 'croupier.
              Debe ser igual a 0, o menor que la cantidad de jugadores o 'croupier
    - card: Carta que se quiere agregar al mazo del jugador
Salida: Estado de juego con el mazo del jugador que se indicó actualizado con la nueva
        carta en su mazo
Ejemplos de uso:
    - >(define game(new-game '("Foo" "Bar" "Baz")))
      >(put-card game 'croupier '(3 clovers)) 
        >>> '((("Foo"...)) ("Bar"...) ("Baz"...))(croupier active ((3 clovers)))())
|#

(define (put-card game player card)
    ;permite reutilizar la función de update-player
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


#| Función next-turn-aux
Descripción: Recorre una lista de jugadores y decide a cuál le toca tomar
             turno, dado el identificador del último jugador que tomó turno.
             Para eso compara primero si hay jugadores de mayor id activo,
             luego busca un jugador de menor id, si no encuentra otro jugador,
             verifica si el último jugador sigue activo y le permite repetir
             turno, de lo contrario, retorna '()
Entradas: 
    - playing: lista de estados de jugadores activos de una partida con sus id's
               como primer elemento (obtenido de la función (active-players))
    - last-player: identificador de último jugador en tomar su turno
Salida: Siguiente jugador a tomar turno, o '() si ningún jugador puede tomar turno
Ejemplos de uso:
    - >(define game(new-game '("Foo" "Bar" "Baz")))
      >(next-turn-aux (active-players game) 0) 
        >>> '(1 "Bar" active ())
|#

(define (next-turn-aux playing last-player)
    ;función que busca un jugador cuyo id cumpla con la condición dada por predicate    
    (define (look-for-active ilist predicate)
        {cond
            [{null? ilist} '()]
            [{predicate (caar ilist) last-player}{car ilist}]
            [else {look-for-active (cdr ilist) predicate}] 
        })
    {cond
        [{null? playing}'()]
        ;busca un jugador activo con mayor id
        [{null? (look-for-active playing >)}
            {cond
                ;busca un jugador activo con mayor id, si no, verifica si jugador puede repetir turno
                [{null? (look-for-active playing <)}{look-for-active playing =}]
                [else {look-for-active playing <}]
            }]
        [else {look-for-active playing >}]
    })


#| Función next-turn 
Descripción: Si existe algun jugador activo, basado en el índice que representa al
             último jugador en terminar su turno, decide por medio de round-robin
             cuál es el siguiente jugador 
Entradas: 
    - game: Juego en el cuál se quiere buscar cuál es el siguiente jugador en tomar su turno 
    - last-player: índice identificador del último jugador en tomar su turno
Salida: 
Ejemplos de uso:
    - >(define game(new-game '("Foo" "Bar" "Baz")))(next-turn game 1) >>> '(2 "Baz" active ())
|# 

(define (next-turn game last-player)
    {cond
        [{not (null? (active-players game))}{next-turn-aux (active-players game) last-player}]
        [else '()]
    })


#| Función has-aces
Descripción: Verifica si una lista de cartas dada contiene un As de valor 11
Entradas: 
    - ilist: lista de entrada que contiene el conjunto a verificar
Salida: #t si el conjunto dado tiene un As de valor 11, #f de lo contrario
Ejemplos de uso:
    - >(has-aces '((3 pikes)(11 hearts)(11 clovers))) >>> #t
    - >(has-aces '((3 pikes)(5 hearts)(10 clovers))) >>> #f
|#

(define (has-aces ilist)
    {cond
        [{or 
            (in-list? '(11 hearts) ilist) (in-list? '(11 diamonds) ilist) 
            (in-list? '(11 pikes) ilist) (in-list? '(11 clovers) ilist)}#t]
        [else #f]
    })


#| Función
Descripción: Toma una lista de cartas, y de encontrar un As de valor 11, lo intercambia
             por un As de valor 11. Solo un As es cambiado.
Entradas: 
    - ilist: lista de cartas de entrada
    - olist: inicializada en '(). Almacena las cartas procesadas que no han sido ases de 
             valor 11
Salida: Si la lista original tenía un As de valor 11, retorna la lista con ese As cambiado
        a un as de valor 1, de lo contrario, retorna la misma lista de entrada
Ejemplos de uso:
    - >(change-one-ace '((3 pikes)(11 hearts)(11 clovers)) '()) 
        >>> '((3 pikes) (1 hearts) (11 clovers))
|#

(define (change-one-ace ilist olist)
    {cond
        [{null? ilist} {reverse olist}]
        [{eq? (caar ilist) 11} {change-one-ace '() (append (reverse(cdr ilist)) (cons (list 1 (cadar ilist)) olist))}]
        [else {change-one-ace (cdr ilist) (cons (car ilist) olist)}]
    })


#| Función try-changing-aces
Descripción: Dado un jugador con puntaje actual mayor a 21 trata de convertir una cantidad de 
            Ases de valor 11 en Ases de valor 1 con el objetivo de reducir el puntaje debajo
            de un 22. Como resultado se obtiene la mejor combinación de valores para el jugador
            dada su mano actual.
Entradas: 
    - player: jugador cuyo puntaje se quiere mejorar
Salida: Mejor combinación posible de valores que el jugador puede tener con su mano actual
Ejemplos de uso:
    - >(try-changing-aces '(Foo active ((11 pikes)(2 hearts)(jack diamonds))) 
        >>> '(Foo active ((2 hearts) (jack diamonds) (1 pikes)))
|# 
(define (try-changing-aces player)
    (define (new-player-state){update-player-hand player (change-one-ace (held-cards player) '())})
    {cond
        [{> 22 (raw-score player)}player]
        [{has-aces (held-cards player)}
            {cond
                [{> 22 (raw-score (new-player-state))}{new-player-state}]
                [else {try-changing-aces (new-player-state)}]
            }]
        {else player}
    })

;------------------- game state change functions END

#| Función new-game-aux
Descripción: Se encarga de la elaboración de una lista de estados de jugadores a partir
             de una lista de nombres dada para que la función "new-game" pueda crear un
             nuevo estado de juego
Entradas: 
    - player-names: lista de nombres de jugadores a ser asignados un estado de juego
    - player-list: lista almacena los estados de juego que se han ido generando
Salida: Lista de estados de juego para los diferentes nombres provistos
Ejemplos de uso:
    - >(new-game-aux '("Foo" "Bar")) >>> '((Foo active ())(Bar active ()))
|#

(define (new-game-aux player-names player-list)
    {cond
        [{null? player-names}{reverse player-list}]
        [else {new-game-aux 
                (cdr player-names)
                (cons (create-player (car player-names)) player-list)
        }]
    })


#| Función new-game
Descripción: Genera un nuevo estado de juego a partir de nombres de jugadores
Entradas: 
    - player-names: nombres de los jugadores presentes en la partida
Salida: Estado del juego nuevo que incluye los nombres dados como jugadores, este
        estado es de forma ((estados jugadores)(estado croupier)(cartas tomadas del mazo))
Ejemplos de uso:
    - >(define new-game '("Foo" "Bar")) 
        >>> '(((Foo active ())(Bar active ()))(croupier active ())()) 
|#

(define (new-game player-names)
    {list (new-game-aux player-names '()) (create-player 'croupier) '()})


#| Función game-finished?
Descripción: Determina si el estado de juego dado es un estado final
Entradas: 
    - game: Juego cuyo estado quiere verificars
Salida: Booleano que indica si el juego ya terminó o no
Ejemplos de uso:
    - >(define game '(((Foo 'stood (...))(Bar 'stood (...))(Baz 'lost (...)))(croupier 'lost)(...)))
      >(game-finished? game) >>> #t
|#

(define (game-finished? game)
    {and (null? (active-players game)) (not (active? (croupier game)))})


#| Función scoreboard
Descripción: Genera una lista de jugadores ordenada por puntaje
Entradas: 
    - game: Estado de juego del que se determina la tabla
Salida: Lista de jugadores con nombre, puntuación y resultado
Ejemplos de uso:
    - >(define game ...)(scoreboard game)
        >>> '((0 "Foo" 20 wins) (1 "Baz" 18 loses) (2 "Bar" 17 tie))
|#

(define (scoreboard game)
    (define (outcome player)
        {cond [{lost? player} 'loses]

              [{or (lost? (croupier game))
                   (> (score player) (score (croupier game)))}
               'wins]

              [{< (score player) (score (croupier game))}
               'loses]

              [{not (= (score player) 21)}
               'tie]

              [{and (= (length (taken-cards player)) 2)
                    (> (length (taken-cards (croupier game))) 2)}
               'wins]

              [{and (> (length (taken-cards player)) 2)
                    (= (length (taken-cards (croupier game))) 2)}
               'loses]

              [else 'tie]})

    (define (add-with-outcome output players)
        {cond [{null? players} output]
              [else (add-with-outcome
                        (cons (list (- (length players) 1)
                                    (name (car players))
                                    (score (car players))
                                    (outcome (car players)))

                              output)

                        (cdr players))]})

    {add-with-outcome
        '() (quicksort (players game) (lambda (a b) (< (score a) (score b))))})
