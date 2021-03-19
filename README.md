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
mainfont: Arial
sansfont: Arial
monofont: DejaVuSansMono.ttf 
mathfont: texgyredejavu-math.otf 
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

### Algoritmo General de Resolución

El algoritmo de resolución del programa se encuentra descrito en el siguiente diagrama:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/Diagrama-BlackjackCE-Page-1.png)

Como se puede observar, inicialmente se realizan algunas tareas que forman parte de una rutina de preparación para entrar en el *game loop* en sí. Funciones como `run-game` se encargan del cargado inicial de la interfaz, y `initial-grab` prepara la mesa de juego en sí.

Por defecto, el jugador uno es el primero en comenzar su turno. Si el jugador decide plantarse, el juego cambia su estado a uno inactivo y pasa a calcular cual es el jugador cuyo turno es el siguiente. Si el jugador decide tomar carta, suceden una serie de verificaciones varias, algunas son omitidas en el diagrama para ofrecer una mayor claridad del flujo del programa.

Si bien se omiten algunas funciones de verificación de estado, es importante remarcar otras unidades funcionales las cuales se omitieron del diagrama para la solución general puesto que su desarrollo podía dificultar la legibilidad del diagrama.

Uno de estos algoritmos es el quicksort, el cual es utilizado en la rutina de comparación de puntajes antes de la muestra de puntajes:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/Diagrama-qs.png)

El funcionamiento de este algoritmo es difícil de representar en un diagrama finito, por lo cual se utilizan las líneas punteadas para indicar que en la zonas demarcadas sucede auto-replicado del diagrama, la cual alcanza profundidades distintas dependiendo de la situación específica en la que se llamó la función.

La forma en la que opera el quicksort es singular. Es un algoritmo basado en la técnica de divide y vencerás. En su forma más pura, consiste en tomar una lista, seleccionar un pivote basado en una heurística definida, y dividir la lista en tres grupos (o dos, dependiendo de la literatura utilizada o conveniencia del caso), una lista de elementos mayores al pivote, menores al pivote, e iguales al pivote. La función quicksort retorna entonces la unión de el resultado de aplicar quicksort sobre estas tres listas. Como se puede predecir, el algoritmo solo alcanzará su nivel de profundidad final cuando el pivote sea el único elemento restante. Al llegar a una lista de un solo elemento, el algoritmo comienza a devolverse nivel por nivel hasta alcanzar el nivel de profundidad inicial y retornar el valor de la lista original de entrada, pero ordenada.

Para el quicksort implementado en el proyecto, se utilizó la composición de funciones para permitir establecer el criterio de evaluación a utilizar que defina los conceptos de menor, mayor e igual para cada ejecución del algoritmo, es decir, el algoritmo funciona independientemente de la clase de elemento a comparar o jerarquía de los elementos de la lista a ordenar.  

Otro algoritmo del programa a notar es la implementación de _Round-Robin_ para decidir el siguiente jugador. 

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/Diagrama-next-turn.png)

Se usan los símbolos que en un diagrama de flujo que indican "salida" puesto que en este punto del programa el algoritmo retorna un valor, con una consecuencia general en el _game loop_, la cual se indica en el diagrama general.

Por último, otro algoritmo a tomar en cuenta es el utilizado para modelar la interacción con los ases. En teoría, un jugador puede asignarle un valor de 1 a un as cuando lo recibe, sin embargo, siempre esta en su conveniencia tomar el valor de 11 por defecto, y solo disminuír el valor del as en caso de sobrepasarse. Esta condición implica que no es necesario ofrecer un botón adicional para este comportamiento, puesto que es redundante, pero sí es esencial que el programa maneje los casos de sobrepaso para evitar que un as de valor 11 sea la causa de pérdida de una partida.

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/Diagrama-try-changing-aces.png)

Al igual que otras implementaciones de blackjack como videojuego, el programa hecho tiene una rutina que busca un as en la mano del jugador solo si el mismo se encuentra en una situación de sobrepaso. De encontrar un as o varios, cambia la cantidad de ases necesarios para evitar un sobrepaso, ni más ni menos.


## 1.2. Funciones implementadas


### `(accept-card player card)`

**Descripción:** Agrega una nueva carta a la mano de un jugador.

**Entradas:** 

- player: lista de estado del jugador al que se le quiere agregar una carta en su mazo.
- card: Carta a agregar al mazo del jugador.

**Salida:** Nuevo estado de jugador ahora con la carta dada incluída en su mano.

**Ejemplo de uso:** 

```Scheme
    >(accept-card '("Foo" active ()) '(5 clovers))
    '("Foo" active ((5 clovers)))
```

### `(active? player)`

**Descripción:** Dado un jugador, retorna si el mismo se encuentra activo o no.

**Entradas:** 

-  player: jugador del cual se quiere saber si se encuentra activo.

**Salida:** #t si el jugador está activo, #f de lo contrario.

**Ejemplo de uso:** 

```Scheme
    >(active? ("Foo" active '()))
    #t
    >(active? '("Bar" stood '()))
    #f
```

### `(active-players game)`

**Descripción:** Obtiene la lista de jugadores activos de una partida junto con su número de turno identificador.

**Entradas:** 

- game: Juego del que se quieren obtener los jugadores activos.

**Salida:** lista de jugadores activos de la partida "game".

**Ejemplo de uso:** 

```Scheme
    >(define game (new-game '("Foo" "Baz")))(active-players game)
    '((0 "Foo" active ())(1 "Baz" active ()))
```

### `(active-players-aux players id olist)` 

**Descripción:** Recorre una lista de jugadores y crea otra lista con los jugadores activos de la primera, asegurándose de que el identificador asignado sea congruente con la posición del jugador en el juego.

**Entradas:** 

- players: lista de jugadores a ser recorrida.
- id: debe inicializarse en 0.
- olist: Deber ser inicializada en '(). En esta lista se van agragando todos los jugadores activos de una partida.

**Salida:** Lista de jugadores activos con sus respectivos identificadores como primer elemento.

**Ejemplo de uso:** 

```Scheme
    >(active-players-aux '(("Foo" active ())
                           ("Bar" stood (king clovers))
                           ("Baz" active ())) 0 '()) 
    '((0 "Foo" active ())(2 "Baz" active ()))
```

### `(add-name-fields dialog up-to next fields)`

**Descripción:** Genera una lista de campos de texto para nombres de jugador a utilizada por `start-game`.

**Entradas:**

- dialog: Diálogo, instancia `dialog%`, al cual se agregarán los campos 
- up-to: Máximo número de jugador a incluir, entero positivo.
- next: Número del siguiente jugador por campo, inicialmente debe ser 1.
- fields: Campos ya generados, en orden inverso, para uso recursivo.

**Salida:** Los campos de texto insertados en respectivo orden, siendo cada uno instancia de `text-field%`.

**Ejemplos de uso:**

```Scheme
    >(add-name-fields dialog 3 1 empty)
    (list #| tres campos de texto |#)
```

### `(add-taken-card game card)`

**Descripción:** Agrega una carta a la lista de cartas en uso de un juego.

**Entradas:** 

- game: Juego cuya lista de cartas tomadas será modificada.
- card: Carta a agregar a la lista de cartas tomadas de "game".
  
**Salida:** Estado resultante de "game" al agregar la carta "card".

**Ejemplo de uso:**

 ```Scheme
    >(define game ...) (add-taken-card game (3 clovers)) 
    '(((Foo...)(Bar...)(Baz...))(croupier...)((3 clovers)...))
```

### `(animate-deck-grab canvas remaining)`

**Descripción:** Dibuja rápidamente varias versiones del mazo en donde la última carta se desplaza progresivamente a la derecha, otorgando una impresión de movimiento.

**Entradas:**

- canvas: Lienzo de dibujo del mazo.
- remaining: Lista de cartas que sobrarán una vez que la última carta ya no sea visible.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(animate-deck-grab deck 51)
      ; Sale la carta superior de un mazo completo
```

### `(ask-player-names up-to then allow-blanks)`

**Descripción:** Pregunta al usuario por nombres de jugadores para un nuevo juego en un cuadro de diálogo.

**Entradas:**

- up-to: Número máximo de jugadores, entero positivo.
- then: Función que admita un único argumento con la lista de nombres.
- allow-blanks (opcional): Si se indica `#t`, entonces se aceptarán nombres en blanco. La lista pasada a `then`  estará filtrada de nombres en blanco. La única restricción será que haya al menos un nombre no vacío.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(ask-player-names 3 start-game)
```

### `(bCEj player-count)`

**Descripción:** Entrypoint de la aplicación, siendo player-count` es la cantidad de jugadores. La descripción de esta función y su prototipo se incluye en la especificación, por lo cual no debe modificarse.

**Entradas:**

- player-count: Número de jugadores, entero entre 1 y 3, ambos inclusive.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(bCEj 3)  ; Aparece la interfaz de usuario
```

### `(card-bitmap card)`

**Descripción:** Asocia una carta con su bitmap. Si la carta se encuentra cargada, la operación será inmediata. De lo contrario, ocurrirá una carga de almacenamiento secundario y un proceso de decodificación de duración corta pero notable.

**Entradas:**

- card: Carta para la cual se busca un bitmap.

**Salida:** De tener éxito, una instancia de `bitmap%`.

**Ejemplos de uso:**

```Scheme
    >(card-bitmap '(queen pikes))
    #| bitmap de una reina de espadas |#
```

### `(card-canvas container)`

**Descripción:** Obtiene el lienzo de un marco contenedor donde se dibujan las cartas del participante.

**Entradas:**

- container (implícita): Marco contenedor.

**Salida:** Instancia de `canvas%`.

**Ejemplos de uso:**

```Scheme
    >(card-canvas croupier-container)
```

### `(card-symbol card)`

**Descripción:** Dado un par que representa una carta, obtiene el segundo elemento el cual representa su símbolo.

**Entradas:** 

- card: Carta de la cual se quiere extraer el símbolo.

**Salida:** Símbolo de la carta dada.

**Ejemplo de uso:** 

```Scheme
    >(card-symbol '(queen diamonds))
    'diamonds
```

### `(card-value card)`

**Descripción:** Dado un par que representa una carta, obtiene el primer elemento el cual representa su valor.

**Entradas:** 

- card: carta cuyo valor se quiere conocer.
  
**Salida:** valor de la carta.

**Ejemplo de uso:** 

```Scheme
    >(card-value '(queen diamonds))
    'queen
```

### `(change-one-ace ilist olist)`

**Descripción:** Toma una lista de cartas, y de encontrar un as de valor 11, lo intercambia por un as de valor 11. Solo un as es cambiado.

**Entradas:** 

- ilist: lista de cartas de entrada.
- olist: inicializada en '(). Almacena las cartas procesadas que no han sido ases de valor 11.

**Salida:** Si la lista original tenía un as de valor 11, retorna la lista con ese as cambiado a un as de valor 1, de lo contrario, retorna la misma lista de entrada.

**Ejemplo de uso:**

```Scheme
    >(change-one-ace '((3 pikes)(11 hearts)(11 clovers)) '()) 
    '((3 pikes) (1 hearts) (11 clovers))
```

### `(code-symbol card)`

**Descripción:** Identifica un símbolo de carta basado en un valor numérico (usado para generación aleatoria de cartas).

**Entradas:** 

- code: número que representa uno de los símbolos de un mazo de cartas.

**Salida:** Valor de símbolo correspondiente al número dado.

**Ejemplo de uso:** 

```Scheme
    >(code-symbol 2)
    'diamonds
```

### `(create-player name)`

**Descripción:** crea una lista que representa el estado de un jugador a partir de un nombre dado.

**Entradas:** 

- name: nombre para el jugador a ser generado 
  
**Salida:** lista que representa el estado de un jugador con el nombre provisto.

**Ejemplo de uso:** 

```Scheme
    >(create-player "Foo")
    '("Foo" active ())
```

### `(create-card value symbol)`

**Descripción:** Crea un par que representa una carta a partir de un valor numérico y un símbolo dados.

**Entradas:** 

- value: Orden de la carta en un conjunto de cartas de un símbolo.
- symbol: símbolo del conjunto de cartas a la que pertenece la carta a crear.

**Salida:** Un par (valor símbolo) que representa una carta. De tener el parámetro value un valor de 11,12 o 13, en la posición respectiva al valor de la carta se cambiará el valor por 'jack, 'queen y 'king respectivamente.

**Ejemplo de uso:** 

```Scheme
    >(create-card 2 'hearts)
    '(2 hearts)
    >(create-card 11 'pikes)
    '(jack pikes)
```

### `(croupier game)`

**Descripción:** Obtiene la lista que representa el estado del croupier.

**Entradas:** 

- game: Juego del cual se quiere obtener el estado del croupier.

**Salida:** Lista que representa estado del croupier.

**Ejemplo de uso:** 

```Scheme
    >(define game (new-game '("Foo" "Baz")))(croupier game)
    '(croupier active ())
```

### `(current-cards container)`

**Descripción:** Obtiene el parámetro variable de cartas de un marco contenedor.

**Entradas:**

- container (implícita): Marco contenedor.

**Salida:** Función que al llamarse con aridad cero se comporta como un getter de cartas actuales, y al invocarse con un argumento se comporta como setter.

**Ejemplos de uso:**

```Scheme
    >((current-cards croupier-container) '((5 hearts) (9 diamonds)))
```

### `(draw-deck canvas dc count swipe-factor)`

**Descripción:** Dibuja el mazo, posiblemente con un corrimiento de animación.

**Entradas:**

- canvas: Lienzo de dibujo.
- dc: Contexto de dibujo.
- count: Número de cartas en el mazo, sin contar la desplazada.
- swipe-factor (opcional): Fracción que indica qué tanto debe mostrarse desplazada la última carta del mazo, medida en unidades del ancho de una carta.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(draw-deck canvas dc 52)      ; Dibuja un mazo completo
    >(draw-deck canvas dc 51 0.5)  ; Igual, pero desplaza la última carta
```

### `(draw-stack canvas dc cards)`

**Descripción:** Dibuja las cartas en manos de un participante.

**Entradas:**

- canvas: Lienzo de dibujo.
- dc: Contexto de dibujo.
- cards: Lista de cartas a dibujar.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(draw-stack canvas dc '((5 hearts) (9 pikes)))
```

### `(end-of-game game deck croupier window then)`

**Descripción:** Realiza acciones finales y termina una partida, mostrando la tabla de puntuaciones.

**Entradas:**

- game: Estado de juego hasta este punto.
- deck: Marco contenedor del mazo.
- croupier-container: Marco contenedor de juego del croupier.
- window: Ventana principal de juego.
- then: Véase parámetro `then` de `show-score`.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(end-of-game ... (λ (restart?) ...))
```

### `(flip container duration action)`

**Descripción:** Reproduce asíncronamente un efecto de toma de carta mientras ejecuta una acción con un tiempo de retardo final.

**Entradas:**

- container: Marco contenedor del participante.
- duration: Duración de retardo, real positivo.
- action: Una función de aridad cero.

**Salida:** `(action)`

**Ejemplos de uso:**

```Scheme
    >(flip 0.25 (λ () ...))
     ; Se actualiza visualmente la puntuación
```

### `(game-container parent name custom-draw initial-cards)`

**Descripción:** Crea un marco contenedor para un participante.

**Entradas:**

- parent: Elemento gráfico padre.
- name: Nombre del participante.
- custom-draw (opcional): Función que debe admitir llamadas de la forma `(custom-draw canvas dc current-cards)`, donde `canvas` y `dc` son los objetos típicamente asociados a ambos nombres, y `current-cards` es el estado actual en ese punto del parámetro variable de cartas actuales. Si no se especifica se asume `draw-stack`.
- initial-cards (opcional): Cartas iniciales bajo control de este marco; se asume '() si no se especifica.   Puede ser un objeto arbitrario en caso de presentarse `custom-draw`, de lo contrario debe ser una lista de cartas.

**Salida:** Un marco contenedor visible bajo `parent`, manipulable a través de `container-label`, `score-label`, `card-canvas` y `current-cards`. Si no se especificó `custom-draw`, se colocará una etiqueta con puntuación nula automáticamente.

**Ejemplos de uso:**

```Scheme
    >(game-container window "Foo")
```

### `(game-finished? game)`

**Descripción:** Determina si el estado de juego dado es un estado final.

**Entradas:** 

- game: Juego cuyo estado quiere verificars.

**Salida:** Booleano que indica si el juego ya terminó o no.

**Ejemplo de uso:** 

```Scheme
    >(define game '((("Foo" 'stood (...))("Bar" 'stood (...))("Baz" 'lost (...)))
                    (croupier 'lost)(...)))
    >(game-finished? game)
    #t
```

### `(get-player game id)`

**Descripción:** Conveniencia para obtener sea un jugador o el croupier.

**Entradas:** 

- game: Estado de juego del cual se quiere obtener un jugador.
- id: 'croupier, o un identificador de jugador válido.

**Salida:** Participante según identificador.

**Ejemplo de uso:** 

```Scheme
    >(define game ...)(get-player game 1)
    '("Foo" stood (...))
    >(get-player game 'croupier)
    '(croupier active (...))
```

### `(get-text-width dc text font)`

**Descripción:** Determina el ancho que tendrá un fragmento de texto cuando sea renderizado.

**Entradas:**

- dc: Contexto de dibujo, instancia de `dc%`.
- text: Texto a medir, debe ser una cadena.
- font (opcional): Fuente contra la cual medir, instancia de `font%`; por defecto se asume la fuente en uso activo para `dc`.

**Salida:** Tamaño, medido en unidades base de dibujo, del texto cuando sea renderizado con la fuente en cuestión.

**Ejemplos de uso:**

```Scheme
    >(get-text-width dc "Jack")
    52
```

### `(grab game deck container player-id)`

**Descripción:** Transfiere una carta del mazo hacia un participante, realizando las acciones, animaciones y efectos de interfaz que esto implique.

**Entradas:**

- game: Estado de juego hasta el momento.
- deck: Marco contenedor del mazo.
- container: Marco contenedor del participante.
- player-id: Índice del jugador participante, o `'croupier`.

**Salida:** Nuevo estado de juego

**Ejemplos de uso:**

```Scheme
    >(grab game deck croupier-container 'croupier)
      ; El croupier adquiere una carta más en su mano
```

### `(has-aces ilist)`

**Descripción:** Verifica si una lista de cartas dada contiene un as de valor 11.

**Entradas:** 

- ilist: lista de entrada que contiene el conjunto a verificar.

**Salida:** #t si el conjunto dado tiene un as de valor 11, #f de lo contrario.

**Ejemplo de uso:**

```Scheme
    >(has-aces '((3 pikes)(11 hearts)(11 clovers)))
    #t
    >(has-aces '((3 pikes)(5 hearts)(10 clovers)))
    #f
```

### `(has-stood? player)`

**Descripción:** Dado un jugador, retorna si el mismo se encuentra plantado o no.

**Entradas:** 

-  player: jugador del cual se quiere saber si se encuentra plantado.

**Salida:** #t si el jugador está plantado, #f de lo contrario.

**Ejemplo de uso:** 

```Scheme
    >(has-stood? ("Foo" stood '()))
    #t
    >(has-stood? '("Bar" active '()))
    #f
```

### `(held-cards player)`

**Descripción:** Dado un par que representa un jugador, retorna la lista de cartas en posesión de dicho jugador, en de pila (última tomada va primero).

**Entradas:** 

- player: lista que representa al jugador del cual se quiere saber su lista de cartas.

**Salida:** Lista de cartas en posesión del jugador.

**Ejemplo de uso:** 

```Scheme
    >(held-cards '("Foo" active ((3 clovers)(5 diamonds))))
    '((3 clovers)(5 diamonds))
```

### `(in-list? element ilist)`

**Descripción:** Verifica si un elemento dado se encuentra dentro de una lista.

**Entradas:** 

- element: valor a buscar en la lista.
- ilist: lista en la que se buscará element.

**Salida:** Valor booleano que indica si el elemento dado efectivamente es miembro de la lista dada.

**Ejemplo de uso:** 

```Scheme
    >(in-list? 3 '(2 3 5))
    #t
    >(in-list? 3 '(2 4 5))
    #f
```

### `(initial-grab game deck container player-id)`

**Descripción:** Toma cartas para un participante hasta que las reglas de juego indiquen que está listo para iniciar.

**Entradas:**

- game: Estado de juego hasta el momento.
- deck: Marco contenedor del mazo.
- container: Marco contenedor del participante.
- player-id: Índice de jugador, o `'croupier`.

**Salida:** El estado de juego una vez tomadas las cartas iniciales del participantes.

**Ejemplos de uso:**

```Scheme
    >(length
        (taken-cards
          (croupier (initial-grab 
                    (new-game "Foo") 
                    deck 
                    croupier-container 
                    'croupier))))
    2
```

### `(list-get list position)`

**Descripción:** Obtiene el elemento de una lista ubicado en el índice dado.

**Entradas:**

- list: Lista de la cuál se extrae el elemento.
- position: Índice en el cual se encuentra el elemento que se busca.

**Salida:** Si la lista tiene un elemento dicho índice, retorna el elemento, de lo contrario emite un mensaje de error que indica que los parámetros son erróneos.

**Ejemplo de uso:**

```Scheme
    >(list-get '(1 2 3 4) 2) 
    3
```

### `(load-bitmap path)`

**Descripción:** Carga y decodifica un bitmap a partir del directorio de recursos.

**Entradas:**

- path: Ruta al bitmap, relativa a la raíz de recursos, sin extensión.

**Salida:** De tener éxito, una instancia de `bitmap%`.

**Ejemplos de uso:**

```Scheme
    >(load-bitmap "cards/5D")
    #| bitmap de un 5 de rombos |#
```

### `(load-progress gauge)`

**Descripción:** Incrementa una barra de progreso de carga.

**Entradas:**

- gauge: Barra de progreso, o `#f`; en el último caso no se realiza acción.

**Salida:** `(void)`.

**Ejemplos de uso:**

```Scheme
    >(load-progress gauge)
      ; Visualmente, la barra de progreso avanza en una unidad
```

### `(lost? player)`

**Descripción:** Dado un jugador, retorna si el mismo ya perdió.

**Entradas:** 

-  player: jugador del cual se quiere saber si perdió.

**Salida:** #t si el jugador perdió, #f de lo contrario.

**Ejemplo de uso:** 

```Scheme
    >(lost? ("Foo" lost '()))
    #t
    >(lost? '("Bar" active '()))
    #f
```

### `(maybe-lost player)`

**Descripción:** Modifica una lista de estado de jugador para representar que el mismo ha perdido en caso de que su puntuación exceda 21.

**Entradas:** 

- player: Jugador que puede haber perdido.

**Salida:** Lista de nuevo estado de jugador.

**Ejemplo de uso:** 

```Scheme
    >(maybe-lost '("Foo" active ()))
    '("Foo" active ())
    >(maybe-lost '("Foo" active ((10 jack) (10 jack) (10 jack))))
    '("Foo" lost (...))
```

### `(maybe-stand-croupier player)`

**Descripción:** Si el jugador indicado es el croupier, se encuentra activo y además su puntuación es al menos 17, provoca que se plante, finalizando el juego. De lo contrario, retorna su entrada.

**Entradas:** 

- player: Jugador que posiblemente es el croupier en estado final.

**Salida:** Lista de nuevo estado de jugador.

**Ejemplo de uso:** 

```Scheme
    >(maybe-stand-croupier '(croupier active ((11 hearts) (9 pikes))))
    '(croupier stood (...))
```

### `(name player)`

**Descripción:** Dado un par que representa un jugador, retorna el nombre del mismo.

**Entradas:** 

- player: lista que representa al jugador del cual se quiere obtener el nombre del jugador.

**Salida:** Nombre del jugador correspondiente al estado de jugador dado.

**Ejemplo de uso:** 

```Scheme
    >(name '("Foo" active ((3 clovers)(5 diamonds))))
    "Foo"
```

### `(new-game player-names)`

**Descripción:** Genera un nuevo estado de juego a partir de nombres de jugadores.

**Entradas:** 

- player-names: nombres de los jugadores presentes en la partida.

**Salida:** Estado del juego nuevo que incluye los nombres dados como jugadores, este estado es de forma ((estados jugadores)(estado croupier)(cartas tomadas del mazo)).

**Ejemplo de uso:**

```Scheme
    >(define new-game '("Foo" "Bar")) 
    '((("Foo" active ())("Bar" active ()))(croupier active ())()) 
```

### `(new-game-aux player-names player-list)`

**Descripción:** Se encarga de la elaboración de una lista de estados de jugadores a partir de una lista de nombres dada para que la función "new-game" pueda crear unnuevo estado de juego.

**Entradas:** 

- player-names: lista de nombres de jugadores a ser asignados un estado de juego.

- player-list: lista almacena los estados de juego que se han ido generando.

**Salida:** Lista de estados de juego para los diferentes nombres provistos.

**Ejemplo de uso:**

```Scheme
    >(new-game-aux '("Foo" "Bar"))
    '(("Foo" active ())("Bar" active ()))
```

### `(next-turn game last-player)`

**Descripción:** Si existe algun jugador activo, basado en el índice que representa al último jugador en terminar su turno, decide por medio de round-robin cuál es el siguiente jugador.

**Entradas:** 

- game: Juego en el cuál se quiere buscar cuál es el siguiente jugador en tomar su turno.
- last-player: índice identificador del último jugador en tomar su turno.

**Salida:** 

**Ejemplo de uso:**

```Scheme
    >(define game(new-game '("Foo" "Bar" "Baz")))(next-turn game 1)
    '(2 "Baz" active ()) 
```

### `(next-turn-aux playing last-player)`

**Descripción:** Recorre una lista de jugadores y decide a cuál le toca tomar turno, dado el identificador del último jugador que tomó turno. Para eso compara primero si hay jugadores de mayor id activo, luego busca un jugador de menor id, si no encuentra otro jugador, verifica si el último jugador sigue activo y le permite repetir turno, de lo contrario, retorna '().

**Entradas:** 

- playing: lista de estados de jugadores activos de una partida con sus id's como primer elemento (obtenido de la función (active-players)).
- last-player: identificador de último jugador en tomar su turno.

**Salida:** Siguiente jugador a tomar turno, o '() si ningún jugador puede tomar turno.

**Ejemplo de uso:**

```Scheme
    >(define game(new-game '("Foo" "Bar" "Baz")))
    >(next-turn-aux (active-players game) 0) 
    '(1 "Bar" active ())
```

### `(play-background-music)`

**Descripción:** Crea un hilo verde que reproduce música de fondo en bucle infinito.

**Salida:** El custodian dedicado para el hilo verde que reproduce la música de fondo.

**Ejemplos de uso:**

```Scheme
    >(play-background-music)
```

### `(players game)`

**Descripción:** Obtiene la lista de jugadores de un estado de juego dado.

**Entradas:** 

- game: Estado de juego del cual se quiere obtener la lista de jugadores.

**Salida:** Lista de jugadores del estado de juego "game".

**Ejemplo de uso:** 

```Scheme
    >(define game ...)(players game)
    '(("Foo"...)("Bar"...)("Baz"...))
```

### `(player-count game)`

**Descripción:** Retorna la cantidad de jugadores en el juego.

**Entradas:** 

- game: Juego cuya cantidad de jugadores quiere conocerse.

**Salida:** cantidad de jugadores en "game".

**Ejemplo de uso:** 

```Scheme
    >(define game (new-game '("Foo" "Baz")))(player-count game)
    2
```

### `(player-state player)`

**Descripción:** Dado un par que representa un jugador, retorna el estado  (active, stood, lost) del mismo.

**Entradas:** 

- player: lista que representa al jugador del cual se quiere saber el estado.

**Salida:** Retorna si el jugador tiene como estado active,stood o lost.

**Ejemplo de uso:** 

```Scheme
    >(player-state '("Foo" active ((3 clovers)(5 diamonds))))
    'active
```

### `(preload-bitmaps gauge)`

**Descripción:** Precarga en memoria y decodifica los bitmaps que la aplicación requerirá, con tal de evitar pausas durante la ejecución mientras estos se cargan.

**Entradas:**

- gauge (opcional): Barra de progreso a incrementar mientras se procesan bitmaps.

**Salida:** `(void)`.

**Ejemplos de uso:**

```Scheme
    >(load-bitmaps)  ; Durará algunos segundos
```

### `(put-card game player card)`

**Descripción:** Agrega una carta al mazo de un jugador que se encuentra activo en una partida. No agrega la carta a la lista de cartas tomadas de juego, puesto que durante la generación de la carta dicha tarea ya se lleva a cabo.

**Entradas:** 

- game: Juego en que se encuentra el jugador al que se le quiere agregar una carta.
- player: Es un entero que identifica a un jugador por orden, o el átomo 'croupier. Debe ser igual a 0, o menor que la cantidad de jugadores o 'croupier.
- card: Carta que se quiere agregar al mazo del jugador.

**Salida:** Estado de juego con el mazo del jugador que se indicó actualizado con la nueva carta en su mazo.

**Ejemplo de uso:**

```Scheme
    >(define game(new-game '("Foo" "Bar" "Baz")))
    >(put-card game 'croupier '(3 clovers)) 
    '((("Foo"...)) ("Bar"...) ("Baz"...))(croupier active ((3 clovers)))())
```

### `(qs-equal ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote para verificar si sus valores son iguales. Los elementos que al ser comparados con el pivote den un resultado true serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada.

**Entradas:**

- ilist: Lista de entrada.
- pivot: Elemento a compararse contra cada elemento de la lista dada. 
- olist: Lista en la que se guardan aquellos elementos de igual valor que el pivote. Debe ser inicializada en '() para uso de la función.

**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada.

**Ejemplo de uso:**

```Scheme
    >(qs-equal '(2 8 4 2 3 4 5 4 1 6 7 4) > 4 '())
    (4 4 4 4)
```

### `(qs-major ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote utilizando la función parámetro de comparación "predicate". Los elementos que al ser comparados con el pivote den un resultado true serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada.

**Entradas:**

- ilist: Lista de entrada.
- predicate: Es una función que toma dos elementos de la lista y determina si el primero se debe ordenar como menor que el segundo.
- pivot: Elemento a compararse contra cada elemento de la lista dada.
- olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote usando la función "predicate" de como resultado #t. Debe ser inicializada en '() para uso de la función.
  
**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada.

**Ejemplo de uso:**

```Scheme
    >(qs-major '(8 4 2 3 1 6 7) > 4 '())
    (1 3 2)
```

### `(qs-minor ilist predicate pivot olist)`

**Descripción:** Compara cada elemento de una lista contra un pivote utilizando la función parámetro de comparación "predicate". Los elementos que al ser comparados con el pivote den un resultado false serán agregados a una lista que se da como resultado de la función al finalizar de procesar la lista de entrada.

**Entradas:**

- ilist: Lista de entrada.
- predicate: Es una función que toma dos elementos de la lista y determina si el primero se debe ordenar como menor que el segundo.
- pivot: Elemento a compararse contra cada elemento de la lista dada.
- olist: Lista en la que se guardan aquellos elementos cuya comparación contra el pivote usando la función "predicate" de como resultado #f. Debe ser inicializada en '() para uso de la función.


**Salida:** Contenido final de olist al finalizar el recorrido por la lista de entrada.

**Ejemplo de uso:**

```Scheme
    >(qs-minor '(8 4 2 3 1 6 7) > 4 '())
    (7 6 8)
```

### `(quicksort ilist predicate)`

**Descripción:** Ordena una lista dada utilizando una implementación de quicksort.

**Entradas:**

- ilist: Lista a ordenar usando quicksort.
- predicate: Función que toma dos elementos y determina si el primero se debe ordenar como menor que el segundo.

**Salida:** Lista de entrada ordenada.

**Ejemplo de uso:**

```Scheme
    >(quicksort '(2 3 4 1 1 2 5) <) 
    '(1 1 2 2 3 4 5)
    >(quicksort '(2 3 4 1 1 2 5) >) 
    '(5 4 3 2 2 1 1)
    >(define game ...) 
    >(quicksort (players game) 
                (lambda (a b) (> (score a) (score b))))
    '(("Bar" #f 21) ("Foo" #f 18) ("Baz" #f 11))
```

### `(random-card)`

**Descripción:** Genera un par que representa una carta de un mazo de manera aleatoria.

**Salida:** Par carta generada de forma aleatoria.

**Ejemplo de uso:**

 ```Scheme
    >(random-card)
    '(10 pikes)
```

### `(raw-score player)`

**Descripción:** Equivalente a `score`, pero no ignora cartas que exceden el puntaje más allá 21.

**Entradas:** 

- player: jugador cuyo puntaje se quiere obtener.

**Salida:** Puntaje que suman las cartas en posesión del jugador.

**Ejemplo de uso:**

```Scheme
    >(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds))))
    12
```

### `(ready? player)`

**Descripción:** Determina si un participante ha tomado suficientes cartas para iniciar.

**Entradas:** 

- player: jugador del cual se quiere saber si ha tomado suficientes cartas.

**Salida:** #t si el jugador ha tomado al menos dos cartas, #f de lo contrario.

**Ejemplo de uso:** 

```Scheme
    >(ready? '("Foo" active '()))
    #f
    >(ready? '("Foo" active '((4 clovers) (3 hearts))))
    #t
```

### `(run-game player-names splash-gauge)`

**Descripción:** Ejecuta una nueva partida de juego. Muestra la ventana principal de juego, coloca e inicializa elementos de interfaz, provoca las acciones iniciales del juego y determina la secuencia de desarrollo de la partida en función de subsecuentes cambios de estado. Al terminar la secuencia, acciona los procesos de puntaje y finalización/reinicio.

**Entradas:**

- player-names: Lista de al menos un nombre de jugador como cadenas de texto.
- splash-gauge (opcional): Barra de progreso de carga, a incrementar conforme progresa la carga y cuya ventana será eliminada al terminar la carga.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(run-game '("Foo" "Bar" "Baz") (splash-screen))
; Muestra un splash mientras se inicia una nueva partida
```

### `(score player)`

**Descripción:** Toma una lista de estado de un jugador y calcula el puntaje que suman las cartas en su mano.

**Entradas:** 

- player: jugador cuyo puntaje se quiere obtener.

**Salida:** Puntaje que suman las cartas en posesión del jugador.

**Ejemplo de uso:**

```Scheme
    >(score '("Foo" active ((3 pikes)(4 hearts)(5 diamonds))))
    12
```

### `(score-aux cards previous-sum score-sum limit-to-21?)`

**Descripción:** Basada en la lista de cartas, retorna el puntaje que suman sus cartas. Se encarga de descifrar el puntaje que agregan las cartas de valor no numérico. Nótese que no es posible exceder una puntuación de 21, por lo que al perder el juego la última carta no altera la puntuación.

**Entradas:** 

- cards: Lista de cartas cuyo puntaje quiere sumarse.
- previous-sum: suma de puntaje justo antes de sumada la última carta en el valor contenido en `score-sum`.
- score-sum: valor numérico que contiene el puntaje que se suma conforme se recorre la lista de cartas. Debe inicializarse en 0.
- limit-to-21?: indica si deben ignorarse cartas que provoquen que el puntaje se sobrepase de 21 o no.

**Salida:** Puntaje que suma la lista de cartas dada.

**Ejemplo de uso:**

```Scheme
    >(score-aux '((3 clovers)(5 diamonds)) 0 0)
    8
```

### `(score-label container)`

**Descripción:** Obtiene la etiqueta de puntaje de un marco contenedor.

**Entradas:**

- container (implícita): Marco contenedor.

**Salida:** Instancia de `message%` que muestra la puntuación actual.

**Ejemplos de uso:**

```Scheme
    >(score-label croupier-container)
```

### `(set-stood player)`

**Descripción:** Modifica una lista de estado de jugador para representar que el mismo se encuentra plantado.

**Entradas:** 

- player: Jugador que se quiere indicar que se plantó.

**Salida:** Lista de nuevo estado de jugador.

**Ejemplo de uso:** 

```Scheme
    >(set-stood '("Foo" active ()))
    '("Foo" stood ())
```

### `(shown-cards all-cards container player-id)`

**Descripción:** Transforma una lista de cartas de participante en una lista de cartas a mostrar, posiblemente reemplazando la primera con lo que gráficamente es una carta oculta.

**Entradas:**

- all-cards: Todas las cartas del participante descubiertas.
- container: Marco contenedor del participante.
- player-id: Índice del jugador participante, o `'croupier`.

**Salida:** Una lista de cartas, donde si alguna carta fue ocultada será reemplaza con `'hidden`.

**Ejemplos de uso:**

```Scheme
    >(shown-cards (cards (croupier game)) croupier-container 'croupier)
    '('hidden ...)
```

### `(show-score game window then)`

**Descripción:** Muestra la tabla de puntuaciones y determina si el juego debe reiniciarse o finalizarse.

**Entradas:**

- game: Estado de juego hasta este punto.
- window: Ventana principal de juego, a como fue generada por `new-game`.
- then: Función que debe aceptar un único argumento booleano `restart?`, el cual determina si la decisión fue reiniciar o finalizar.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(show-score game window (λ (restart?) #| acción posterior |#))
```

### `(stand player)`

**Descripción:** Indica que el participante player, expresado como un entero correspondiente a un jugador o el 'croupier, se ha plantado. Retorna el nuevo estado de juego.

**Entradas:** 

- game: Juego al que pertenece el jugador que quiere indicarse como plantado.
- player: identificador del jugador (croupier inclusive) a ser indicado como plantado.

**Salida:** Nuevo estado de juego con lista de jugadores actualizada para mostrar el cambio en el estado del jugador plantado.

**Ejemplo de uso:**

```Scheme
    >(define game(new-game '("Foo" "Bar" "Baz")))
    >(stand game 0) 
    '((("Foo" stood ()) ("Bar" active ()) ("Baz" active ()))
      (croupier active ())())
    >(stand game 1)
    '((("Foo" active ()) ("Bar" stood ()) ("Baz" active ()))
      (croupier active ())())
    >(stand game 2)
    '((("Foo" active ()) ("Bar" active ()) ("Baz" stood ()))
      (croupier active ())())
    >(stand game 'croupier)
    '((("Foo" active ()) ("Bar" active ()) ("Baz" active ()))
      (croupier stood ())())
```

### `(start-game player-names)`

**Descripción:** Inicia una instancia del juego, mostrando una pantalla de splash mientras carga.

**Entradas:**

- player-names: Lista de al menos un nombre de jugador, debe ser una lista de cadenas.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(start-game '("Foo" "Bar" "Baz"))
```

### `(splash-screen)`

**Descripción:** Genera y muestra una pantalla de carga con un fondo aleatorio.

**Salida:** El `gauge%` asociado a la barra de progreso, en un estado indefinido. El caller es responsable de definirle un rango e incrementarlo.

**Ejemplos de uso:**

```Scheme
    >(splash-screen)  ; A partir de aquí la pantalla de carga es visible
```

### `(take-card game)`

**Descripción:** Dado un estado de juego, agrega una carta a la lista de cartas tomadas y comunica la carta tomada junto con el nuevo estado de juego.

**Entradas:** 

- game: Juego al cual se quiere agregar una carta en uso.

**Salida:** Par que contiene la carta tomada y el nuevo estado de juego que lista dicha carta como usada.

**Ejemplo de uso:** 

```Scheme
    >(take-card game) 
    '((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
```

### `(take-card-aux game card)`

**Descripción:** Ayuda a la función take-card a agregar la carta dada al estado de juego a ser devuelto.

**Entradas:** 

- game: Juego al que se quiere agregar una carta tomada.
- card: Carta que se quiere registrar como tomada.
  
**Salida:** Un par que tiene de primer elemento la carta tomada, y de segundo elemento el nuevo estado de juego de "game" en el que "card" se encuentra en la lista de cartas tomadas.

**Ejemplo de uso:** 

```Scheme
    >(take-card-aux game '(6 clovers)) 
    '((6 clovers)((Foo...)(Bar...)(Baz...))(croupier...)((6 clovers)...))
```

### `(taken-cards game)`

**Descripción:** Obtiene la lista de cartas que han sido tomadas del mazo y se encuentran en juego.

**Entradas:** 

- game: Estado de juego del cual se quieren saber las cartas usadas.

**Salida:** Lista de cartas en juego de la partida dada.

**Ejemplo de uso:** 

```Scheme
    >(define game ...)(taken-cards game)
    '((1 hearts)(5 diamonds)(11 pikes))
```

### `(try-changing-aces player)`

**Descripción:** Dado un jugador con puntaje actual mayor a 21 trata de convertir una cantidad de Ases de valor 11 en Ases de valor 1 con el objetivo de reducir el puntaje debajo de un 22. Como resultado se obtiene la mejor combinación de valores para el jugador dada su mano actual.

**Entradas:** 

- player: jugador cuyo puntaje se quiere mejorar.

**Salida:** Mejor combinación posible de valores que el jugador puede tener con su mano actual.

**Ejemplo de uso:**

```Scheme
    >(try-changing-aces '("Foo" active ((11 pikes)(2 hearts)(jack diamonds))) 
    '("Foo" active ((2 hearts) (jack diamonds) (1 pikes)))
```

### `(update-cards container cards)`

**Descripción:** Actualiza las cartas actuales de un marco contenedor.

**Entradas:**

- container: Marco contenedor para el que se actualizarán sus cartas.
- cards: Nuevas cartas, aceptando el tipo esperado por la función responsable de dibujar este marco en cuestión, por lo cual no necesariamente es una lista de cartas (véase el parámetro `custom-draw` de la función `game-container`).

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(update-cards container (taken-cards (car (players game))))
```

### `(update-player predicate index updated)`

**Descripción:** Aplica una función modificador a un jugador de una lista identificado por un índice. Obtiene la nueva lista de jugadores con el jugador del índice especificado con su estado actualizado.

**Entradas:** 

- predicate: es la operación modificadora a aplicar a cada jugador.
- index: índice de la lista en el que se encuentra el jugador. Empieza desde 0 y en un juego de 3 el máximo es 2.
- updated: Debe inicializarse en '(). Almacena la lista de jugadores ya procesados.

**Salida:** Lista de jugadores con el estado del jugador especificado actualizada.

**Ejemplo de uso:**

```Scheme
    >(define game (new-game '("Foo" "Bar")))
    >(update-player set-stood (players game) 0 '()) 
    '(("Foo" stood ()) ("Bar" active ()))
```

### `(update-player-hand player new-hand)`

**Descripción:** Reemplaza la mano del un jugador por una nueva mano representada como una lista de cartas.

**Entradas:** 

- player: Jugador cuya mano se quiere cambiar.
- new-hand: Nueva lista de cartas para el jugador.

**Salida:** Estado del jugador luego de cambiar su mano.

**Ejemplo de uso:** 

```Scheme
    >(update-player-hand '("Foo" active ()) '((11 clovers)(3 pikes)))
    '("Foo" active ((11 clovers)(3 pikes)))
```

### `(update-score container score)`

**Descripción:** Actualiza los elementos gráficos asociados a la puntuación de un participante de juego.

**Entradas:**

- container: Marco contenedor del participante.
- score: Nueva puntuación, entero no negativo.

**Salida:** `(void)`

**Ejemplos de uso:**

```Scheme
    >(update-score croupier-container 17)
     ; Se actualiza visualmente la puntuación
```

## 1.3. Estructuras de datos desarrolladas

### **Representación de cartas**

**Descripción**

Es un conjunto de pares implementado con listas de Racket. En una lista de cartas, ninguna carta puede estar repetida. La representación se muestra a continuación.

```Scheme
'((valor símbolo)(valor símbolo)(valor símbolo))
```

Un ejemplo de uso se da en la lista de cartas que usa el juego para verificar que cartas del mazo han sido ya utilizadas

``` Scheme
'((11 hearts)(jack diamonds)...[])
```

Estas listas se utilizan como elementos hijos de estructuras mayores, jugadores y estados de juego.


### **Representación de jugadores**

**Descripción**

Los jugadores se describen como una lista de Racket de 3 elementos: 

- Nombre
- Estado de juego (activo, plantado o perdedor)
- Lista de cartas que representa la mano del jugador

```Scheme
'(Nombre estado (lista de cartas))
```

La estructura de un jugador llamado Foo, activo en primer turno, y con un blackjack en mano se vería de la siguiente manera:

```Scheme
'("Foo" active ((11 pikes)(king hearts)))
```

### **Representación de un estado de juego**

**Descripción**

Es una lista Racket que a su vez contiene 3 sublistas, y dos de estas sublistas contienen sus propias sublistas. 

```Scheme
'((jugadores) croupier (cartas tomadas))
```

El primer elemento es una lista que representa a los jugadores de la partida, excluyendo al croupier. 

```
((Nombre1 estado1 (lista-cartas1)) (Nombre2 estado2 (lista-cartas2))...[etc])
```

La lista que representa al croupier es igual al de un jugador normal, pero se prefirió colocarlo en una posición separada de la lista para facilitar el acceso a los datos del croupier. Este elemento solo puede tener en el espacio de nombre "croupier"

```Scheme
'(croupier active ((11 pikes)(king hearts)))
```

El tercer elemento es la lista de cartas, cuya implementación ya se cubrió anteriormente.

Un ejemplo de un estado inicial de juego con 3 jugadores se vería de la siguiente manera:

```Scheme
'(((jose active ((10 hearts)(8 pikes)))
   (maria active ((5 hearts)(2 diamonds)))
   (pedro active ((jack pikes)(2 clovers)))),
  (croupier active ((11 clovers)(3 hearts))),
  ((10 hearts)(8 pikes)(5 hearts)(2 diamonds)
   (jack pikes)(2 clovers)(11 clovers)(3 hearts)))
```

## 1.4 Problemas no solucionados

No se encontraron problemas que no se hayan resolvido.

## 1.5. Problemas encontrados y solucionados

### Bugs menores encontrados en la etapa final

1. **Greedy croupier**: 
   
   * *Descripción*: Cuando el croupier obtenía un puntaje que sumaba 17 o más con sus primeras dos cartas se marcaba a sí mismo como plantado. Este comportamiento era esperado, pero una consecuencia no prevista era que uno de los condicionales de la función que asignaba turnos `next-turn` requería un croupier activo, o de lo contrario empezaba la rutina final en la que el croupier toma cartas. El problema que surgía en esta situación es que la función `game-finished?` chequea si hay jugadores activos **y**  si el croupier ya perdió. Como la función de asignar turnos fallaba, efectivamente quedaban jugadores activos, y el croupier seguía tomando cartas ya que su condicional para seguir tomando cartas era el valor de retorno de `game-finished?`, el cual en este caso seguiría siendo `#t` hasta un tiempo indefinido.
   
   * *Intentos de solución sin éxito*: Inicialmente se creyó que el problema tenía que ver con una función que confirmaba si el crupier debía detenerse o asumir un estado de "lost", se modificaron algunos valores de las funciones momentáneamente. Si bien no la causa, esta era una de las funciones involucradas en el bug, por lo cual este intento terminó siendo la base para encontrar el verdadero problema.
   
   * *Solución*: Se cambió el condicional de la función que decidía próximo turno para que en vez de verificar el estado del croupier, verificara la presencia de jugadores activos. Ambos condicionales son relativamente equivalentes, solo que el segundo evita el problema de que un crupier sea marcado como inactivo en el primer turno.

2. **Situación de nunca blackjack**:
   
   * *Descripción*: El problema consistía en que los jugadores, al tomar un as y una carta de valor 10, en vez de plantarse con un puntaje de 21, cambiaban de manera automática un as de valor 11 por uno de valor 1. Igual habían comportamientos similares en caso de alcanzar el 21. Este problema se debía a una equivocación en el valor escogido para comparar contra el puntaje del jugador. La función `try-changing-aces` intercambiaba un as del jugador inclusive en las situaciones en las que tenía un 21 y no le convenía en absoluto. Esto era porque la condicional permitía un cambio de as si al cambiar un as el puntaje era estrictamente menor a 21.
   
   * *Intentos de solución*: Inicialmente se exploró el problema. No hubo intentos de solución fallidos per se, pero si una rutina de pruebas que permitió identificar el origen del problema, lo que al final llevó a la solución efectiva del mismo.
  
   * *Solución*: Se logró solucionar el problema cambiando el valor contra ekl que se comparaba el puntaje del jugador, pasándolo de 21 a 22. Además se mejoró el código para evitar que las cartas del jugador se vieran desordenadas luego de tratar de cambiar un as.

3. **Nunca se descubre la primera carta del croupier**

   * Descripción: Cuando el croupier llega a una puntuación de 17 o más con
	 solamente las dos cartas iniciales.

   * Solución: Se movió la condición gráfica de cubrimiento y descubrimiento a
	 su propia función. Al inicio de la etapa final del juego, se refresca el
	 área del croupier con la lista de cartas indicadas por esta función, en
	 vez de depender de que más cartas sean insertadas para invocar el
	 refrescado.

## 1.6. Plan de Actividades

El registro del plan de actividades se llevó a cabo en una tabla de excel. La misma se puede ver en línea en el siguiente link:

<https://estudianteccr-my.sharepoint.com/:x:/g/personal/josfemova_estudiantec_cr/EdpIY5FMafRGoKklTgOMdgkBAk4891vVfR0VT2qTk_yCvQ?e=OWfe6d> 

Seguidamente, se incluyen las capturas del plan:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/actividades1.PNG)

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/actividades2.PNG)

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/actividades3.PNG)

## 1.7. Conclusiones

- Se implementó de manera exitosa un programa de funcionalidad compleja en un lenguaje funcional, de esta manera se demostró que la capacidad de implementar un programa es independiente del paradigma de un lenguaje de programación, lo que puede variar es la dificultad, pero no la posibilidad.
- Durante el proceso de correción de problemas se observó que la herramienta más útil para este proceso es el trabajo en equipo y una buena coordinación entre los colaboradores.
- Los problemas experimentados demuestran que es fundamental listar por adelantado todas las posibles excepciones a reglas generales de un programa (los llamados _corner cases_). Si bien con los problemas descritos la dificultad de resolución no fue mayor, no se podría afirmar que en todo caso que se dé una situación similar la dificultad de resolución sería la misma.
- Se comprueba la utilidad de los mecanismos de manejo de funciones de alto orden provistos por Racket, puesto que poder recibir funciones como argumento de una función permite desarrollar algortimos sin necesidad de definir varios detalles de casos específicos, es decir, propicia la reutilizacipon de código y evita el problema de verse forzado en hacer implementaciones varias de un mismo algoritmo por diferencias menores entre los datos siendo procesados.


## 1.8. Recomendaciones

- Si bien como ejercicio propio de programación puede ser útil, el desarrollo de aplicaciones de interfaz gráfica en el lenguaje Racket es algo deficiente en comparación a lenguajes más dominantes.
- Racket es un lenguaje algo ineficiente con el uso de memoria. De ser esta una limitante para una implementación, se recomienda evitar el uso de este lenguaje en estos casos.
- Para evitar un uso de memoria desmedido al renderizar elementos gráficos es deseable recurrir a efectos visuales que den la apariencia de ser más complejos de lo que de verdad son.
- Para trabajos de programación que integran a varios colaboradores se recomienda propiciar una buena comunicación y coordinación, no solo respecto a horarios y fechas de trabajo, pero también respecto a las tareas técnicas desarrolladas por cada miembro, esto porque es particularmente útil cuando surgen problemas en las secciones del proyecto en las cuales hay interacción entre las lógicas desarrolladas por los distintos colaboradores.

## 1.9. Bibliografía consultada en todo el proyecto

Guzman, J. E. (2006). Introducción a la programación con Scheme. Cartago:
Editorial Tecnológica de Costa Rica.

Arkadium. (2016). _Free Online Blackjack Game | Play Blackjack Online for Free_$\text{[videojuego]}$. Disponible en:
<https://www.arkadium.com/games/blackjack/>

Flatt M., Findler R., Clements J. (s.f). _The Racket Graphical Interface Toolkit_.
Obtenido de: <https://docs.racket-lang.org/gui/>

Flatt M., Findler R., Clements J. (s.f). _The Racket Drawing Toolkit_.
Obtenido de: <https://docs.racket-lang.org/draw/>

Flatt M., Findler R., Clements J. (s.f). _Custodians_.
Obtenido de: <https://docs.racket-lang.org/reference/eval-model.html?q=thread#%28part._custodian-model%29>

Flatt M., Findler R., Clements J. (s.f). _raco: Racket Command Line Tools_.
Obtenido de: <https://docs.racket-lang.org/raco/>

 Andersen. L. (2016). _Subproccesses remain alive after Racket program halts_.
 Obtenido de: <https://stackoverflow.com/questions/39358725/subproccesses-remain-alive-after-racket-program-halts/39358912#39358912>

## Recursos gráficos

Escape One. (2014, 30 de noviembre). _Las Vegas Casino Music Video: For Night Game of Poker, Blackjack, Roulette Wheel & Slots_
$\text{[video]}$. YouTube. <https://youtu.be/GKtlRchHpx8>

American Contract Bridge League. (s.f.). _52 Playing Cards_$\text{[imágenes]}$. Obtenido de:
<https://acbl.mybigcommerce.com/52-playing-cards/>

Orange Free Sounds. (2018). _Card Flip Sound Effect_$\text{[audio]}$. Obtenido de:
<https://orangefreesounds.com/card-flip-sound-effect/>




