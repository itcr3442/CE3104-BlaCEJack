## 5 de marzo

- Se forman grupos de trabajo y se publica la especificación.

## 6 de marzo y 7 de marzo

- El grupo de trabajo coordina aspectos de organización.
- Se acuerda definir, de manera inicial, una lista de
  prototipos de funciones y otros artefactos requeridos por la
  especificación.
- Se acuerdan diseños a gran escala de lógica e interfaz.

## 8 de marzo

- Se escribe una revisión inicial de la lista de funciones a
  implementar junto a sus descripciones.

## 9 de marzo

- Se discute entre el equipo de trabajo el caso de que un
  jugador y el croupier pierdan en la misma partida,
  concluyendo que la lista de funciones actuales no considera
  esto apropiadamente. Se decide representar con símbolos
  ternarios el estado de actividad de un jugador.

## 11 de marzo

- Se exportan del archivo de lógica las funciones que la interfaz
  necesitará.
- Se agrega una ventana de diálogo para preguntar los nombres de los
  jugadores.  Por cada jugador, se presenta un campo de texto. El diálogo
  incluye un botón para iniciar el juego.
- Se agrega una ventana que será la principal área del juego. Tanto cada
  jugador como el croupier disponen de una casilla en la ventana con su
  nombre, puntaje actual y cartas. En la parte inferior de la ventana se
  ubica el nombre del jugador actual y botones para tanto tomar otra
  carta como plantarse.
- Se implementa la rotación de turnos de jugadores en la interfaz
  gráfica.
- Se hace que la puntuación del croupier no sea visible durante la
  primera fase del juego.
- Se busca, encuentra e integra un paquete de imágenes de cartas.
- Se implementa el dibujo de las cartas en el marco de cada participante.
- Se implementa el acomodo de varias cartas en lo que visualmente parece
  ser una pila de cartas. Esto ocurre conforme se avanza y se agregan
  cartas.

## 13 de marzo

- Se encuentra una incompatibilidad menor entre el diseño propuesto y la
  especificación acerca de si debe o no mostrarse la primera carta de cada
  jugador. Se consultará al profesor.
- Se implementa la toma de las dos cartas iniciales para cada participante.
- Las imágenes de cartas ahora se precargan al inicio en vez de al requerirse
  cada una, lo cual mejora el tiempo de respuesta al tomar una carta.
- Ahora se oculta la primera carta de tanto jugadores como croupier.
- Se implementa el deshabilitado de áreas de juego de jugadores que han perdido
  o se han plantado.
- Se agrega un archivo `main.rkt` por conveniencia que evita escribir los
  nombres de jugadores en cada prueba. Será eliminado a futuro.
- Se implementan acciones gráficas referentes al final del juego.
- En respuesta a indicación del profesor, se persiste con el diseño propuesto
  por el equipo de trabajo. Debido a lo anterior, se modificó la interfaz para
  que solo oculte la primera carta del croupier y ninguna otra, y que esta
  misma sea descubierta al momento de comenzar el croupier a tomar cartas.
- Se integra en la función `(accept-card player card)` el soporte existente
  para provocar que un jugador pierda si su puntuación excede 21, así como
  corregir el valor de sus aces de ser posible para tratar de no superar 21.
- Se muestra la puntuación del croupier al comenzar este a tomar cartas.
- Se agrega un efecto de sonido para movimientos de cartas.
- Se agrega una pantalla de splash con una selección de imágenes, esto debido a
  que el tiempo necesario para precargar los bitmaps de cartas es notorio para
  el usuario.

## 14 de marzo

- La pantalla de splash ahora muestra el título "BlaCEJack".
- Se hace que las pilas de cartas por jugador/croupier se centren con respecto
  a sus contenedores.
- Se reemplazan algunos patrones estructurales en `ui.rkt`.
- Los botones de acción (tomar carta y plantarse) ahora se desactivan durante
  transiciones y animaciones causadas por los mismos botones, evitando posibles
  condiciones de carrera que hubieran surgido al presionar varias veces estos
  botones de manera rápida.
- Se agrega una barra de progreso a la pantalla de splash. Este progreso es
  real, producto de los tiempos de carga de bitmaps, y no es dado por estética.
- Se muestra el mazo en el área de juego. Para ello, se genera una imagen
  estática de una pila de cartas grande:
  ```bash
  cp red_back.png many.png
  seq 51 | while read X; do
    convert many.png red_back.png -set page '+%[fx:u[t-1]page.x+u[t-1].w-669]+%[fx:u[t-1]page.y]' -background none -layers merge +repage many.png
  done
  ```
  Esta imagen es luego utilizada como bitmap, recortada según convenga para dar
  la impresión que el mazo está bajando de tamaño, y dibujando al final el
  bitmap de carta oculta.

## 15 de marzo

- Se arregla un bug que ocurría cuando el croupier se plantaba con solo las dos
  cartas iniciales, causando que no se mostrara la primera carta al final.
- Se agrega una referencia bibliográfica para Introducción a la Programción con
  Scheme de Guzmán (2006).
- Se reemplazan las ocurrencias de "hang" por "stand", ya que es el verbo
  correcto.
- Se elimina l función `(high-ace card)`, la cual fue parte del diseño original
  pero ya no tiene un uso actual o esperado.
- Se documentan algunos bugs antes descritos en esta bitácora (ver README.md).
- Se agrega una referencia bibliográfica para `racket/draw`.

## 16 de marzo

- Se implementan aspectos de terminación y reinicio de juego en interfaz.
- Se agregan botones para reiniciar y salir del juego.
- Se escribe una función `(scoreboard game)` que produce la tabla de posiciones
  de jugadores al terminar el juego, incluyendo condiciones de empate y
  aquellas donde el croupier pierde.
- Debido a que `racket/gui` carece de un contenedor de rejilla (grid) o
  semejante, así como la preferencia para no incluir dependencias externas en
  esta fase del proyecto, se escogió implementar la vistas gráfica de la tabla
  de posiciones por medio de cálculos manuales de posiciones sobre un canvas.
  Se toma en cuenta el tamaño de cada columna en función del máximo ancho (en
  píxeles, tras renderizar) de cada fragmento de texto asociado a esa columna.

## 17 de marzo

- Se arregla un bug en las condiciones de gane-pérdida-empate de final de
  juego.  Específicamente, se hubiese considerado incorrectamente como
  blackjack una situación donde tanto jugador como croupier logran 21, con el
  jugador teniendo al menos tres cartas y el croupier más de tres o viceversa.
  Se arregla asegurando que deban ser específicamente dos cartas para
  blackjack.
- Se implementa una animación no fluida (basada en timings estáticos) para la
  acción de tomar una carta del mazo. Con este cambio, se observa
  momentáneamente como la carta que se encontraba en el tope el mazo se mueve
  hacia la derecha para luego reaparecer en donde se necesita.
- Se reducen los tiempos de espera al tomar cartas, para considerar el tiempo
  que toma la animación del mazo.
