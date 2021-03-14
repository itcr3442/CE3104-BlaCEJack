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
