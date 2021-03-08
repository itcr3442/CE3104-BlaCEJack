# CE3104-BlaCEJack

## Algoritmos Desarrollados

## Funciones implementadas

### `(bCEj X)`

Entrypoint de la aplicación, siendo `X` es la cantidad de
jugadores. La descripción de esta función y su prototipo se
incluye en la especificación, por lo cual no debe modificarse.

Precondiciones: `X` se encuentra entre 1 y 3, ambos inclusive.

### `(score player)`

Retorna la puntuación dado el estado de un jugador.

Ejemplo de uso:
```scheme
> (define game ...) (score (car (players game)))
10
```

### `(name player)`

Retorna el nombre del participante `player` si se trata de un
jugador, o el átomo `'croupier` para el croupier.

Ejemplo de uso:
```scheme
> (define game ...) (name (croupier game))
'croupier
> (name (car (players game)))
"Bobby Tables"
```

### `(active? player)`

Retorna si el participante `player` se encuentra activo. Es
decir, si no se ha levantado ni ha perdido.

Ejemplo de uso:
```scheme
> ; Equivalente a (game-finished? game)
> (define game ...) (active? (croupier game))
#f
```

### `(players game)`

Retorna la lista de estados de los jugadores a partir del
estado de juego `game`. El croupier no se incluye aquí; véase
`(croupier game)` para ello.

Ejemplo de uso:
```scheme
> (players (new-game '("Karen")))
'(("Karen" ...))
```

### `(croupier game)`

Retorna el estado del croupier para el estado de juego dado
por `game`. El formato es el mismo que para un jugador
regular.

Ejemplo de uso:
```scheme
> (define game ...) (score (croupier game))
8
```

### `(game-finished? game)`

Este predicado determina si el estado de juego dado por
`game` es un estado final.

Ejemplo de uso:
```scheme
> (game-finished? (new-game ...))
#f
```

### `(take-card game)`

Dado un estado de juego `game`, genera una carta aleatoria que
no haya sido ya tomada del mazo y retorna una pareja de la
forma `(cons card next)`, donde `card` es la carta que ha sido
tomada y `next` es el nuevo estado de juego. Este diseño no
considera la posibilidad de que el mazo se agote.

Ejemplo de uso:
```scheme
> (define game ...) (define card-and-next (take-card game))
> (car card-and-next)
'(6 diamonds)
> (game-finished? (put-card (cdr card-and-next) 'croupier card))
#f
```

### `(put-card game player card)`

Agrega la carta `card` a las del participante `player` en el
estado de juego `game`. `player` es un entero que identifica a
un jugador por orden, o el átomo `'croupier`.

Precondiciones: `player`, en caso de no ser `'croupier`, debe
ser mayor o igual que `0` y menor que la cantidad de jugadores
en la partida. Esta función retorna el nuevo estado de juego.

La puntuación se actualizará según el valor de la carta. En
caso de que la puntuación excedería 21 si la carta se agrega
de la manera usual, se actualizará el estado del participante
para indicar que ya no se encuentra activo pues ha perdido.

Ejemplo de uso:
```scheme
> (define game ...) (score (croupier game))
10
> (score (croupier (put-card game 'croupier (11 pikes))))
21
```

### `(new-game player-names)`

Retorna la lista de estado de una partida, en posiciones
iniciales, dados los nombres de los jugadores. Todos los
participantes, incluido el croupier, inician sin cartas y con
cero puntuación. El caller es responsable de repartir las
primeras cartas utilizando `(take-card ...)` y `(put-card
...)`.

Precondiciones: `player-names` no es una lista vacía.

Ejemplo de uso:
```scheme
> (define game (new-game (list "Foo" "Bar" "Baz")))
> (players game)
'(("Foo" #t 0) ("Bar" #t 0) ("Baz" #t 0)
> (croupier game)
'(croupier #t 0 ())
```

### `(next-turn game last-player)`

Dado el número de jugador `last-player` y estado de juego
`game`:

- Si existe algún otro jugador activo y el crouper sigue
  activo, la función retorna `(cons next-id next)`, donde
  `next-id` es el identificador del jugador para el siguiente
  turno y `next` es la lista de estado de ese jugador.

- De lo contrario, retorna `null` (`'()`).

Los turnos se distribuyen por round-robin. Es posible que el
siguiente turno corresponda al mismo jugador que el del turno
anterior. A diferencia de otras, esta función no acepta
`'croupier` como identificador de participante.

Ejemplo de uso:
```scheme
> (define game ...) (next-turn game 0)
'(1 . ("Bar" #t 5))
```

### `(hang game player)`

Indica que el participante `player`, expresado como un entero
correspondiente a un jugador o el átomo `'croupier`, se ha
plantado. Retorna el nuevo estado de juego.

Ejemplo de uso:
```scheme
> (define game ...) (active? (car (players game)))
#t
> (active? (car (players (hang game 0))))
#f
```

### `(random-card)`

Retorna una carta aleatoria, construida a partir de una pareja
tipo-símbolo válida. Esta función nunca genera un as de 11,
debe utilizarse `(high-ace card)` si eso es lo deseado.

Ejemplo de uso:
```scheme
> (random-card)
'(3 hearts)
> (random-card)
'(jack clovers)
```
Véase descripción y formato de estructura para cartas.

### `(high-ace card)`

Transforma un as de 1 en un as de 11. Si la carta no es un as
se retorna sin cambios.

Ejemplo de uso:
```scheme
> (high-ace '(1 clovers))
'(11 clovers)
> (high-ace '(jack diamonds))
'(jack diamonds)
```

### `(quicksort list predicate)`

Ordena la lista `list` utilizando quicksort. `predicate` es
una función que toma dos elementos de la lista y determina si
el primero se debe ordenar como menor que el segundo.

Ejemplo de uso:
```scheme
> (quicksort '(2 3 4 1 1 2 5) <)
'(1 1 2 2 3 4 5)
> (quicksort '(2 3 4 1 1 2 5) >)
'(5 4 3 2 2 1 1)
> (define game ...) (quicksort (players game) (lambda (a b) (> (score a) (score b))))
'(("Bar" #f 21) ("Foo" #f 18) ("Baz" #f 11))
```

## Estructuras de datos

## Conclusiones

## Recomendaciones

## Bibliografía

[Juego flash](https://www.arkadium.com/games/blackjack/)
[racket/gui](https://docs.racket-lang.org/gui/)


## Link documento plan de actividades: 

<https://estudianteccr-my.sharepoint.com/:x:/g/personal/josfemova_estudiantec_cr/EdpIY5FMafRGoKklTgOMdgkBAk4891vVfR0VT2qTk_yCvQ?e=OWfe6d> 
