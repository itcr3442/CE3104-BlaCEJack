---
title: Instituto Tecnológico de Costa Rica\endgraf\bigskip \endgraf\bigskip\bigskip\
 Tarea Corta 1 - BlaCEJack \endgraf\bigskip\bigskip\bigskip\bigskip


author: 
- José Morales Vargas 
- Alejandro Soto Chacón
  
date: \bigskip\bigskip\bigskip\bigskip Area Académica de\endgraf Ingeniería en Computadores \endgraf\bigskip\bigskip\ Lenguajes, Compiladores \endgraf e intérpretes (CE3104) \endgraf\bigskip\bigskip Profesor Marco Rivera Meneses \endgraf\vfill  Semestre I
header-includes:
- \setlength\parindent{24pt}

lang: es-ES
papersize: letter
classoption: fleqn
geometry: margin=1in
fontfamily: noto
fontsize: 12pt
linestretch: 1.5
...


\maketitle
\thispagestyle{empty}
\clearpage
\tableofcontents
\pagenumbering{roman}
\clearpage
\pagenumbering{arabic}
\setcounter{page}{1}



# CE3104-BlaCEJack

## 1.1. Algoritmos Desarrollados

### Round Robin

### Quicksort

## 1.2. Funciones implementadas

### `(bCEj X)`

Entrypoint de la aplicación, siendo `X` es la cantidad de
jugadores. La descripción de esta función y su prototipo se
incluye en la especificación, por lo cual no debe modificarse.

Precondiciones: `X` se encuentra entre 1 y 3, ambos inclusive.

### `(list-get list position)`

**Descripción:** Obtiene el elemento de una lista ubicado en el índice dado.

**Entradas:** 

- list: Lista de la cuál se extrae el elemento.
- position: Índice en el cual se encuentra el elemento que se busca.

**Salida:** Si la lista tiene un elemento dicho índice, retorna el elemento, de lo contrario emite un mensaje de error que indica que los parámetros son erróneos. 

**Ejemplo de uso:** 

```scheme
>(list-get '(1 2 3 4) 2) 
3
```

### `(qs-minor ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote utilizando la función parámetro de comparación "predicate". Los elementos que al ser comparados con el pivote den un resultado false serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada

**Entradas:** 

- ilist: Lista de entrada 
- predicate: Es una función que toma dos elementos de la lista y determina si el primero se debe ordenar como menor que el segundo.
- pivot: Elemento a compararse contra cada elemento de la lista dada 
- olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote usando la función "predicate" de como resultado #f. Debe ser inicializada en '() para uso de la función


**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada

**Ejemplo de uso:** 

```scheme
>(qs-minor '(8 4 2 3 1 6 7) > 4 '())
(7 6 8)
```

### `(qs-major ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote utilizando la función parámetro de comparación "predicate". Los elementos que al ser comparados con el pivote den un resultado true serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada

**Entradas:** 

- ilist: Lista de entrada 
- predicate: Es una función que toma dos elementos de la lista y determina si el primero se debe ordenar como menor que el segundo.
- pivot: Elemento a compararse contra cada elemento de la lista dada 
- olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote usando la función "predicate" de como resultado #t. Debe ser inicializada en '() para uso de la función
  
**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada

**Ejemplo de uso:** 

```scheme
>(qs-major '(8 4 2 3 1 6 7) > 4 '())
(1 3 2)
```

### `(qs-equal ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote para verificar si sus valores son iguales. Los elementos que al ser comparados con el pivote den un resultado true serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada

**Entradas:** 

- ilist: Lista de entrada 
- pivot: Elemento a compararse contra cada elemento de la lista dada 
- olist: Lista en la que se guardan aquellos elementos de igual valor que el pivote. Debe ser inicializada en '() para uso de la función

**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada

**Ejemplo de uso:** 

```scheme
>(qs-equal '(2 8 4 2 3 4 5 4 1 6 7 4) > 4 '())
(4 4 4 4)
```

### `(quicksort ilist predicate)`

**Descripción:** Ordena una lista dada utilizando una implementación de quicksort

**Entradas:** 

- ilist: Lista a ordenar usando quicksort
- predicate: Función que toma dos elementos y determina si el primero se debe ordenar como menor que el segundo.

**Salida:** Lista de entrada ordenada

**Ejemplo de uso:** 

```scheme
>(quicksort '(2 3 4 1 1 2 5) <) 
'(1 1 2 2 3 4 5)
>(quicksort '(2 3 4 1 1 2 5) >) 
'(5 4 3 2 2 1 1)
>(define game ...) (quicksort (players game) (lambda (a b) (> (score a) (score b))))
'(("Bar" #f 21) ("Foo" #f 18) ("Baz" #f 11))
```


### `(create-card value symbol)`

**Descripción:** Crea un par que representa una carta a partir de un valor numérico y un símbolo dados

**Entradas:** 

- value: Orden de la carta en un conjunto de cartas de un símbolo
- symbol: símbolo del conjunto de cartas a la que pertenece la carta a crear

**Salida:** Un par (valor símbolo) que representa una carta. De tener el parámetro value un valor de 11,12 o 13, en la posición respectiva al valor de la carta se cambiará el valor por 'jack, 'queen y 'king respectivamente.

**Ejemplo de uso:** 

```scheme
>(create-card 2 'hearts)
'(2 hearts)
>(create-card 11 'pikes)
'(jack pikes)
```

### `(card-value card)`

**Descripción:** Dado un par que representa una carta, obtiene el primer elemento el cual representa su valor

**Entradas:** 

- card: carta cuyo valor se quiere conocer
  
**Salida:** valor de la carta

**Ejemplo de uso:** 

```scheme
>(card-value '(queen diamonds))
'queen
```

### `(card-symbol card)`

**Descripción:** Dado un par que representa una carta, obtiene el segundo elemento
             el cual representa su símbolo
**Entradas:** 

- card: Carta de la cual se quiere extraer el símbolo

**Salida:** Símbolo de la carta dada

**Ejemplo de uso:** 

```scheme
>(card-symbol '(queen diamonds))
'diamonds
```

### `(code-symbol card)`

**Descripción:** Identifica un símbolo de carta basado en un valor numérico (usado para generación aleatoria de cartas)
**Entradas:** 

- code: número que representa uno de los símbolos de un mazo de cartas

**Salida:** Valor de símbolo correspondiente al número dado

**Ejemplo de uso:** 

```scheme
>(code-symbol 2)
'diamonds
```

### `(random-card)`

**Descripción:** Genera un par que representa una carta de un mazo de manera aleatoria

**Salida:** Par carta generada de forma aleatoria

**Ejemplo de uso:**

 ```scheme
>(random-card)
'(10 pikes)
```

### `(high-ace card)`

**Descripción:** toma un As con valor de 1 y lo convierte en un As de valor 11

**Entradas:** 

- card: As cuyo valor será aumentado

**Salida:** Si la entrada es un As de valor uno, la salida será un As con valor de 11, de lo contrario solo se retorna la carta dada

**Ejemplo de uso:** 

```scheme
>(high-ace '(1 pikes))
'(11 pikes)
```

### `(taken-cards  game)`

**Descripción:** Obtiene la lista de cartas que han sido tomadas del mazo y se encuentran en juego

**Entradas:** 

- game: Estado de juego del cual se quieren saber las cartas usadas

**Salida:** Lista de cartas en juego de la partida dada

**Ejemplo de uso:** 

```scheme
>(define game ...)(taken-cards game)
'((1 hearts)(5 diamonds)(11 pikes))
```

### `(in-list? element ilist)`

**Descripción:** Verifica si un elemento dado se encuentra dentro de una lista 

**Entradas:** 

- element: valor a buscar en la lista
- ilist: lista en la que se buscará element

**Salida:** Valor booleano que indica si el elemento dado efectivamente es miembro de la lista dada

**Ejemplo de uso:** 

```scheme
>(in-list? 3 '(2 3 5))
#t
>(in-list? 3 '(2 4 5))
#f
```

### `(add-taken-card game card)`

**Descripción:** Agrega una carta a la lista de cartas en uso de un juego

**Entradas:** 

- game: Juego cuya lista de cartas tomadas será modificada
- card: Carta a agregar a la lista de cartas tomadas de "game"
- 
**Salida:** Estado resultante de "game" al agregar la carta "card"

**Ejemplo de uso:**

 ```scheme
>(define game ...) (add-taken-card game (3 clovers)) 
'(((Foo...)(Bar...)(Baz...))(croupier...)((3 clovers)...))
```

### `(take-card-aux game card)`

**Descripción:** Ayuda a la función take-card a agregar la carta dada al estado de juego a ser devuelto

**Entradas:** 

- game: Juego al que se quiere agregar una carta tomada
- card: Carta que se quiere registrar como tomada
- 
**Salida:** Un par que tiene de primer elemento la carta tomada, y de segundo elemento el nuevo estado de juego de "game" en el que "card" se encuentra en la lista decartas tomadas.

**Ejemplo de uso:** 

```scheme
>(take-card-aux game '(6 clovers)) 
'((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
```

### `(take-card game)`

**Descripción:** Dado un estado de juego, agrega una carta a la lista de cartas tomadas y comunica la carta tomada junto con el nuevo estado de juego

**Entradas:** 

- game: Juego al cual se quiere agregar una carta en uso

**Salida:** Par que contiene la carta tomada y el nuevo estado de juego que lista dicha carta como usada

**Ejemplo de uso:** 

```scheme
>(take-card game) 
'((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
```

### `(create-player name)`

**Descripción:** crea una lista que representa el estado de un jugador a partir de un nombre dado

**Entradas:** 

- name: nombre para el jugador a ser generado 
- 
**Salida:** lista que representa el estado de un jugador con el nombre provisto

**Ejemplo de uso:** 

```scheme
>(create-player "Foo")
'("Foo" active ())
```

### `(name player)`

**Descripción:** Dado un par que representa un jugador, retorna el nombre del mismo

**Entradas:** 

- player: lista que representa al jugador del cual se quiere obtener el nombre del jugador

**Salida:** Nombre del jugador correspondiente al estado de jugador dado

**Ejemplo de uso:** 

```scheme
>(name '("Foo" active ((3 clovers)(5 diamonds))))
"Foo"
```

### `(player-state player)`

**Descripción:** Dado un par que representa un jugador, retorna el estado  (active, stood, lost) del mismo

**Entradas:** 

- player: lista que representa al jugador del cual se quiere saber el estado

**Salida:** Retorna si el jugador tiene como estado active,stood o lost

**Ejemplo de uso:** 

```scheme
>(player-state '("Foo" active ((3 clovers)(5 diamonds))))
'active
```

### `(held-cards player)`

**Descripción:** Dado un par que representa un jugador, retorna la lista de cartas en posesión de dicho jugador, en de pila (última tomada va primero).

**Entradas:** 

- player: lista que representa al jugador del cual se quiere saber su lista de cartas

**Salida:** Lista de cartas en posesión del jugador

**Ejemplo de uso:** 

```scheme
>(held-cards '("Foo" active ((3 clovers)(5 diamonds))))
'((3 clovers)(5 diamonds))
```

### `(update-player-hand player new-hand)`

**Descripción:** Reemplaza la mano del un jugador por una nueva mano representada como una lista de cartas

**Entradas:** 

- player: Jugador cuya mano se quiere cambiar
- new-hand: Nueva lista de cartas para el jugador 

**Salida:** Estado del jugador luego de cambiar su mano

**Ejemplo de uso:** 

```scheme
>(update-player-hand '("Foo" active ()) '((11 clovers)(3 pikes)))
'("Foo" active ((11 clovers)(3 pikes)))
```

### `(active? player)`

**Descripción:** Dado un jugador, retorna si el mismo se encuentra activo o no

**Entradas:** 

-  player: jugador del cual se quiere saber si se encuentra activo

**Salida:** #t si el jugador está activo, #f de lo contrario

**Ejemplo de uso:** 

```scheme
>(active? ("Foo" active '()))
#t
>(active? '("Bar" stood '()))
#f
```

### `(lost? player)`

**Descripción:** Dado un jugador, retorna si el mismo ya perdió

**Entradas:** 

-  player: jugador del cual se quiere saber si perdió

**Salida:** #t si el jugador perdió, #f de lo contrario

**Ejemplo de uso:** 

```scheme
>(lost? ("Foo" lost '()))
#t
>(lost? '("Bar" active '()))
#f
```

### `(has-stood? player)`

**Descripción:** Dado un jugador, retorna si el mismo se encuentra plantado o no

**Entradas:** 

-  player: jugador del cual se quiere saber si se encuentra plantado

**Salida:** #t si el jugador está plantado, #f de lo contrario

**Ejemplo de uso:** 

```scheme
>(has-stood? ("Foo" stood '()))
#t
>(has-stood? '("Bar" active '()))
#f
```

### `(ready? player)`

**Descripción:** Determina si un participante ha tomado suficientes cartas para iniciar

**Entradas:** 

- player: jugador del cual se quiere saber si ha tomado suficientes cartas

**Salida:** #t si el jugador ha tomado al menos dos cartas, #f de lo contrario

**Ejemplo de uso:** 

```scheme
>(ready? '("Foo" active '()))
#f
>(ready? '("Foo" active '((4 clovers) (3 hearts))))
#t
```

### `(players game)`

**Descripción:** Obtiene la lista de jugadores de un estado de juego dado

**Entradas:** 

- game: Estado de juego del cual se quiere obtener la lista de jugadores

**Salida:** Lista de jugadores del estado de juego "game"

**Ejemplo de uso:** 

```scheme
>(define game ...)(players game)
'(("Foo"...)("Bar"...)("Baz"...))
```

### `(get-player game id)`

**Descripción:** Conveniencia para obtener sea un jugador o el croupier

**Entradas:** 

- game: Estado de juego del cual se quiere obtener un jugador
- id: 'croupier, o un identificador de jugador válido

**Salida:** Participante según identificador

**Ejemplo de uso:** 

```scheme
>(define game ...)(get-player game 1)
'("Foo" stood (...))
>(get-player game 'croupier)
'(croupier active (...))
```

### `(active-players-aux players id olist)` 

**Descripción:** Recorre una lista de jugadores y crea otra lista con los jugadores activos de la primera, asegurándose de que el identificador asignado sea congruente con la posición del jugador en el juego

**Entradas:** 

- players: lista de jugadores a ser recorrida
- id: debe inicializarse en 0
- olist: Deber ser inicializada en '(). En esta lista se van agragando todos los jugadores activos de una partida

**Salida:** Lista de jugadores activos con sus respectivos identificadores como primer elemento

**Ejemplo de uso:** 

```scheme
>(active-players-aux '(("Foo" active ())("Bar" stood (king clovers))("Baz" active ())) 0 '()) 
'((0 "Foo" active ())(2 "Baz" active ()))
```

### `(active-players game)`

**Descripción:** Obtiene la lista de jugadores activos de una partida junto con su número de turno identificador.

**Entradas:** 

- game: Juego del que se quieren obtener los jugadores activos

**Salida:** lista de jugadores activos de la partida "game"

**Ejemplo de uso:** 

```scheme
>(define game (new-game '("Foo" "Baz")))(active-players game)
'((0 "Foo" active ())(1 "Baz" active ()))
```

### `(player-count game)`

**Descripción:** Retorna la cantidad de jugadores en el juego

**Entradas:** 

- game: Juego cuya cantidad de jugadores quiere conocerse

**Salida:** cantidad de jugadores en "game"

**Ejemplo de uso:** 

```scheme
>(define game (new-game '("Foo" "Baz")))(player-count game)
2
```

### `(croupier game)`

**Descripción:** Obtiene la lista que representa el estado del croupier

**Entradas:** 

- game: Juego del cual se quiere obtener el estado del croupier



**Salida:** Lista que representa estado del croupier
**Ejemplo de uso:** 

```scheme
>(define game (new-game '("Foo" "Baz")))(croupier game)
'(croupier active ())
```

### `(accept-card player card)`

**Descripción:** Agrega una nueva carta a la mano de un jugador

**Entradas:** 

- player: lista de estado del jugador al que se le quiere agregar una carta en su mazo
- card: Carta a agregar al mazo del jugador

**Salida:** Nuevo estado de jugador ahora con la carta dada incluída en su mano

**Ejemplo de uso:** 

```scheme
>(accept-card '("Foo" active ()) '(5 clovers))
'("Foo" active ((5 clovers)))
```

### `(maybe-stand-croupier player)`

**Descripción:** Si el jugador indicado es el croupier, se encuentra activo y además su puntuación es al menos 17, provoca que se plante, finalizando el juego. De lo contrario, retorna su entrada.

**Entradas:** 

- player: Jugador que posiblemente es el croupier en estado final

**Salida:** Lista de nuevo estado de jugador

**Ejemplo de uso:** 

```scheme
>(maybe-stand-croupier '(croupier active ((11 hearts) (9 pikes))))
'(croupier stood (...))
```

### `(maybe-lost player)`

**Descripción:** Modifica una lista de estado de jugador para representar que el mismo ha perdido en caso de que su puntuación exceda 21

**Entradas:** 

- player: Jugador que puede haber perdido

**Salida:** Lista de nuevo estado de jugador

**Ejemplo de uso:** 

```scheme
>(maybe-lost '("Foo" active ()))
'("Foo" active ())
>(maybe-lost '("Foo" active ((10 jack) (10 jack) (10 jack))))
'("Foo" lost (...))
```

### `(set-stood player)`

**Descripción:** Modifica una lista de estado de jugador para representar que el mismo
             se encuentra plantado
**Entradas:** 
- player: Jugador que se quiere indicar que se plantó
**Salida:** Lista de nuevo estado de jugador
**Ejemplo de uso:** 

```scheme
>(set-stood '("Foo" active ()))
'("Foo" stood ())
```

### `(update-player predicate index updated)`

**Descripción:** Aplica una función modificador a un jugador de una lista identificado por un índice. Obtiene la nueva lista de jugadores con el jugador del índice especificado con su estado actualizado

**Entradas:** 

- predicate: es la operación modificadora a aplicar a cada jugador 
- index: índice de la lista en el que se encuentra el jugador. Empieza desde 0 y en un juego de 3 el máximo es 2
- updated: Debe inicializarse en '(). Almacena la lista de jugadores ya procesados

**Salida:** Lista de jugadores con el estado del jugador especificado actualizada

**Ejemplo de uso:**

```scheme
>(define game (new-game '("Foo" "Bar")))(update-player set-stood (players game) 0 '()) 
'(("Foo" stood ()) ("Bar" active ()))
```

### `(score-aux cards previous-sum score-sum limit-to-21?)`

**Descripción:** Basada en la lista de cartas, retorna el puntaje que suman sus cartas. Se encarga de descifrar el puntaje que agregan las cartas de valor no numérico. Nótese que no es posible exceder una puntuación de 21, por lo que al perder el juego la última carta no altera la puntuación.

**Entradas:** 

- cards: Lista de cartas cuyo puntaje quiere sumarse
- previous-sum: suma de puntaje justo antes de sumada la última carta en el valor contenido en `score-sum`
- score-sum: valor numérico que contiene el puntaje que se suma conforme se recorre la lista de cartas. Debe inicializarse en 0 
- limit-to-21?: indica si deben ignorarse cartas que provoquen que el puntaje se sobrepase de 21 o no

**Salida:** Puntaje que suma la lista de cartas dada

**Ejemplo de uso:**

```scheme
>(score-aux '((3 clovers)(5 diamonds)) 0 0)
8
```

### `(score player)`

**Descripción:** Toma una lista de estado de un jugador y calcula el puntaje que suman las cartas en su mano

**Entradas:** 

- player: jugador cuyo puntaje se quiere obtener

**Salida:** Puntaje que suman las cartas en posesión del jugador

**Ejemplo de uso:**

```scheme
>(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds))))
12
```

 ### `(raw-score player)`

**Descripción:** Equivalente a `score`, pero no ignora cartas que exceden el puntaje más allá 21

**Entradas:** 

- player: jugador cuyo puntaje se quiere obtener

**Salida:** Puntaje que suman las cartas en posesión del jugador

**Ejemplo de uso:**

```scheme
>(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds))))
12
```

### `(stand player)`

**Descripción:** Indica que el participante player, expresado como un entero correspondiente a un jugador o el átomo 'croupier, se ha plantado. Retorna el nuevo estado de juego.

**Entradas:** 

- game: Juego al que pertenece el jugador que quiere indicarse como plantado
- player: identificador del jugador (croupier inclusive) a ser indicado como plantado

**Salida:** Nuevo estado de juego con lista de jugadores actualizada para mostrar el cambio en el estado del jugador plantado

**Ejemplo de uso:**

```scheme
>(define game(new-game '("Foo" "Bar" "Baz")))
>(stand game 0) 
'((("Foo" stood ()) ("Bar" active ()) ("Baz" active ()))(croupier active ())())
>(stand game 1)
'((("Foo" active ()) ("Bar" stood ()) ("Baz" active ()))(croupier active ())())
>(stand game 2)
'((("Foo" active ()) ("Bar" active ()) ("Baz" stood ()))(croupier active ())())
>(stand game 'croupier)
'((("Foo" active ()) ("Bar" active ()) ("Baz" active ()))(croupier stood ())())
```

### `(put-card game player card)`

**Descripción:** Agrega una carta al mazo de un jugador que se encuentra activo en una partida. No agrega la carta a la lista de cartas tomadas de juego, puesto que durante la generación de la carta dicha tarea ya se lleva a cabo

**Entradas:** 

- game: Juego en que se encuentra el jugador al que se le quiere agregar una carta 
- player: Es un entero que identifica a un jugador por orden, o el átomo 'croupier.
              Debe ser igual a 0, o menor que la cantidad de jugadores o 'croupier
- card: Carta que se quiere agregar al mazo del jugador

**Salida:** Estado de juego con el mazo del jugador que se indicó actualizado con la nueva carta en su mazo

**Ejemplo de uso:**

```scheme
>(define game(new-game '("Foo" "Bar" "Baz")))
>(put-card game 'croupier '(3 clovers)) 
'((("Foo"...)) ("Bar"...) ("Baz"...))(croupier active ((3 clovers)))())
```

### `(next-turn-aux playing last-player)`

**Descripción:** Recorre una lista de jugadores y decide a cuál le toca tomar turno, dado el identificador del último jugador que tomó turno. Para eso compara primero si hay jugadores de mayor id activo, luego busca un jugador de menor id, si no encuentra otro jugador, verifica si el último jugador sigue activo y le permite repetir turno, de lo contrario, retorna '()

**Entradas:** 

- playing: lista de estados de jugadores activos de una partida con sus id's como primer elemento (obtenido de la función (active-players))
- last-player: identificador de último jugador en tomar su turno

**Salida:** Siguiente jugador a tomar turno, o '() si ningún jugador puede tomar turno

**Ejemplo de uso:**

```scheme
>(define game(new-game '("Foo" "Bar" "Baz")))
>(next-turn-aux (active-players game) 0) 
'(1 "Bar" active ())
```

### `(next-turn game last-player)`

**Descripción:** Si existe algun jugador activo, basado en el índice que representa al último jugador en terminar su turno, decide por medio de round-robin cuál es el siguiente jugador 

**Entradas:** 

- game: Juego en el cuál se quiere buscar cuál es el siguiente jugador en tomar su turno 
- last-player: índice identificador del último jugador en tomar su turno

**Salida:** 

**Ejemplo de uso:**

```scheme
>(define game(new-game '("Foo" "Bar" "Baz")))(next-turn game 1)
'(2 "Baz" active ())
- 
```

### `(has-aces ilist)`

**Descripción:** Verifica si una lista de cartas dada contiene un As de valor 11

**Entradas:** 

- ilist: lista de entrada que contiene el conjunto a verificar

**Salida:** #t si el conjunto dado tiene un As de valor 11, #f de lo contrario

**Ejemplo de uso:**

```scheme
>(has-aces '((3 pikes)(11 hearts)(11 clovers)))
#t
>(has-aces '((3 pikes)(5 hearts)(10 clovers)))
#f
```

### `(change-one-ace ilist olist)`

**Descripción:** Toma una lista de cartas, y de encontrar un As de valor 11, lo intercambia por un As de valor 11. Solo un As es cambiado.

**Entradas:** 

- ilist: lista de cartas de entrada
- olist: inicializada en '(). Almacena las cartas procesadas que no han sido ases de valor 11

**Salida:** Si la lista original tenía un As de valor 11, retorna la lista con ese As cambiado a un as de valor 1, de lo contrario, retorna la misma lista de entrada

**Ejemplo de uso:**

```scheme
>(change-one-ace '((3 pikes)(11 hearts)(11 clovers)) '()) 
'((3 pikes) (1 hearts) (11 clovers))
```

### `(try-changing-aces player)`

**Descripción:** Dado un jugador con puntaje actual mayor a 21 trata de convertir una cantidad de Ases de valor 11 en Ases de valor 1 con el objetivo de reducir el puntaje debajo de un 22. Como resultado se obtiene la mejor combinación de valores para el jugador dada su mano actual.

**Entradas:** 

- player: jugador cuyo puntaje se quiere mejorar

**Salida:** Mejor combinación posible de valores que el jugador puede tener con su mano actual

**Ejemplo de uso:**

```scheme
>(try-changing-aces '(Foo active ((11 pikes)(2 hearts)(jack diamonds))) 
'(Foo active ((2 hearts) (jack diamonds) (1 pikes)))
```

### `(new-game-aux player-names player-list)`

**Descripción:** Se encarga de la elaboración de una lista de estados de jugadores a partir de una lista de nombres dada para que la función "new-game" pueda crear unnuevo estado de juego

**Entradas:** 

- player-names: lista de nombres de jugadores a ser asignados un estado de juego

- player-list: lista almacena los estados de juego que se han ido generando

**Salida:** Lista de estados de juego para los diferentes nombres provistos

**Ejemplo de uso:**

```scheme
>(new-game-aux '("Foo" "Bar"))
'((Foo active ())(Bar active ()))
```

### `(new-game player-names)`

**Descripción:** Genera un nuevo estado de juego a partir de nombres de jugadores

**Entradas:** 

- player-names: nombres de los jugadores presentes en la partida

**Salida:** Estado del juego nuevo que incluye los nombres dados como jugadores, este estado es de forma ((estados jugadores)(estado croupier)(cartas tomadas del mazo))

**Ejemplo de uso:**

```scheme
>(define new-game '("Foo" "Bar")) 
'(((Foo active ())(Bar active ()))(croupier active ())()) 
```

### `(game-finished? game)`

**Descripción:** Determina si el estado de juego dado es un estado final

**Entradas:** 

- game: Juego cuyo estado quiere verificars

**Salida:** Booleano que indica si el juego ya terminó o no

**Ejemplo de uso:** 

```scheme
>(define game '(((Foo 'stood (...))(Bar 'stood (...))(Baz 'lost (...)))(croupier 'lost)(...)))
>(game-finished? game)
#t
````


## 1.3. Estructuras de datos desarrolladas

### **Representación de cartas**

**Descripción**

Es conjunto de pares implementado con listas de racket. En una lista de cartas, ninguna carta puede estar repetida. La representación se muestra a continuación 

```scheme
'((valor símbolo)(valor símbolo)(valor símbolo))
```

Un ejemplo de uso se da en la lista de cartas que usa el juego para verificar que cartas del mazo han sido ya utilizadas

``` Scheme
'((11 hearts)(jack diamonds)...[])
```

Estas listas se utilizan como elementos hijos de estructuras mayores, jugadores y estados de juego.


### **Representación de jugadores**

**Descripción**

Los jugadores se describen como una lista de racket de 3 elementos: 

- Nombre
- Estado de juego (activo, plantado o perdedor)
- Lista de cartas que representa la mano del jugador

```Scheme
'(Nombre estado (lista de cartas))
```

La estructura de un jugador llamado Foo, activo en primer turno, y con un blackjack en mano se vería de la siguiente manera:

```Scheme
'(Foo active ((11 pikes)(king hearts)))
```

### **Representación de un estado de juego**

**Descripción**

Es una lista racket que a su vez contiene 3 sublistas, y dos de estas sublistas contienen sus propias sublistas. 

```Scheme
'((jugadores),croupier,(cartas tomadas))
```

El primer elemento es una lista que representa a los jugadores de la partida, excluyendo al croupier. 

```
((Nombre1 estado1 (lista-cartas1)) (Nombre2 estado2 (lista-cartas2))...[etc])
```

El átomo que representa al croupier es igual al de un jugador normal, pero se prefirió colocarlo en una posición separada de la lista para facilitar el acceso a los datos del croupier. Este átomo solo puede tener en el espacio de nombre "croupier"

```Scheme
'(croupier active ((11 pikes)(king hearts)))
```

El tercer átomo es la lista de cartas, cuya implementación ya se cubrió anteriormente.

Un ejemplo de un estado inicial de juego con 3 jugadores se vería de la siguiente manera:

```Scheme
'(((jose active ((10 hearts)(8 pikes)))(maria active ((5 hearts)(2 diamonds)))(pedro active ((jack pikes)(2 clovers)))),(croupier active ((11 clovers)(3 hearts))),((10 hearts)(8 pikes)(5 hearts)(2 diamonds)(jack pikes)(2 clovers)(11 clovers)(3 hearts)))
```

## 1.4. Conclusiones

## 1.5. Problemas encontrados

### Bugs menores encontrados en la etapa final

1. **Greedy croupier**: 
   
   * *Descripción*: Cuando el croupier obtenía un puntaje que sumaba 17 o más con sus primeras dos cartas se marcaba a sí mismo como plantado. Este comportamiento era esperado, pero una consecuencia no prevista era que uno de los condicionales de la función que asignaba turnos `next-turn` requería un croupier activo, o de lo contrario empezaba la rutina final en la que el croupier toma cartas. El problema que surgía en esta situación es que la función `game-finished?` chequea si hay jugadores activos **y**  si el croupier ya perdió. Como la función de asignar turnos fallaba, efectivamente quedaban jugadores activos, y el croupier seguía tomando cartas ya que su condicional para seguir tomando cartas era el valor de retorno de `game-finished?`, el cual en este caso seguiría siendo `#t` hasta un tiempo indefinido 
   * *Intentos de solución sin éxito*: Inicialmente se creyó que el problema tenía que ver con una función que confirmaba si el crupier debía detenerse o asumir un estado de "lost", se modificaron algunos valores de las funciones momentáneamente. Si bien no la causa, esta era una de las funciones involucradas en el bug, por lo cual este intento terminó siendo la base para encontrar el verdadero problema
   
   * *Solución*: Se cambió el condicional de la función que decidía próximo turno para que en vez de verificar el estado del croupier, verificara la presencia de jugadores activos. Ambos condicionales son relativamente equivalentes, solo que el segundo evita el problema de que un crupier sea marcado como inactivo en el primer turno.

2. **Situación de nunca blackjack**:
   
   * *Descripción*: El problema consistía en que los jugadores, al tomar un as y una carta de valor 10, en vez de plantarse con un puntaje de 21, cambiaban de manera automática un as de valor 11 por uno de valor 1. Igual habían comportamientos similares en caso de alcanzar el 21. Este problema se debía a una equivocación en el valor escogido para comparar contra el puntaje del jugador. La función `try-changing-aces` intercambiaba un as del jugador inclusive en las situaciones en las que tenía un 21 y no le convenía en absoluto. Esto era porque la condicional permitía un cambio de As si al cambiar un As el puntaje era estrictamente menor a 21.
   
   * *Intentos de solución*: Inicialmente se exploró el problema. No hubo intentos de solución fallidos per se, pero si una rutina de pruebas que permitió identificar el origen del problema, lo que al final llevó a la solución efectiva del mismo.
  
   * *Solución*: Se logró solucionar el problema cambiando el valor contra ekl que se comparaba el puntaje del jugador, pasándolo de 21 a 22. Además se mejoró el código para evitar que las cartas del jugador se vieran desordenadas luego de tratar de cambiar un as.

## 1.6. Plan de Actividades

El registro del plan de actividades se llevó a cabo en una tabla de excel. La misma se puede ver en línea en el siguiente link:

<https://estudianteccr-my.sharepoint.com/:x:/g/personal/josfemova_estudiantec_cr/EdpIY5FMafRGoKklTgOMdgkBAk4891vVfR0VT2qTk_yCvQ?e=OWfe6d> 

Seguidamente, se incluyen las capturas del plan:

![](./doc/actividades1.png)
![](./doc/actividades2.png)
![](./doc/actividades3.png)



## 1.7. Conclusiones.

- 


## 1.8. Recomendaciones.




## 1.9. Bibliografía consultada en todo el proyecto

## Bibliografía

Guzman, J. E. (2006). Introducción a la programación con Scheme. Cartago:
Editorial Tecnológica de Costa Rica.

[Juego flash](https://www.arkadium.com/games/blackjack/)
[racket/gui](https://docs.racket-lang.org/gui/)
[Imágenes de cartas](https://acbl.mybigcommerce.com/52-playing-cards/)
[Sonido de carta](https://orangefreesounds.com/card-flip-sound-effect/)



