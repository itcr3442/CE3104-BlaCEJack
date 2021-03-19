## 6 de Marzo

Me familiaricé un poco más con las mecánicas del juego black-jack recurriendo a la página <https://www.arkadium.com/games/blackjack/> donde se muestra un ejemplo de como operario el juego si fuese jugado por una sola persona

Se realizó la primera reunión para coordinación de proyecto

- El diseño general del proyecto quedó definido
- Tareas iniciales quedaron asignadas

## 7 de marzo:

- Compañero entregó la plan de módulos principales. 

## 8 de marzo:

Diseñé el restante del plan de actividades basado en las reuniones grupales anteriores y el plan de módulos presentado por el compañero. 

Se le propuso al compañero la idea de utilizar una estructura de interfaz gráfica similar al juego que se encuentra en el siguiente enlace:
<https://casualpixel.itch.io/pixel-blackjack>


## 9 de marzo:

- Se implementaron varias de las funciones relacionadas al estado de juego y creación de cartas. 

- También se completó La implementación del quicksort (faltan pruebas de predicados complejos).

- Al final del día se implementaron funciones relacionadas con la interacción del juego.

- Por acuerdo con el compañero, se decidió cambiar la representación de un jugador para representar varias banderas de estado en el segundo elemento, de manera que la representación quede algo como 
('nombre-jugador (active? lost? hanged?) (lista de cartas))
Queda pendiente documentar las funciones desarrolladas de manera completa. 

## 10 de marzo:

- Se volvió a cambiar la representación del jugador para preferir un modelo más conciso. Las banderas de estado han sido cambiadas por un solo átomo cuyo valor en sí es el estado del jugador.

- Además se decidió agregar una función que le permita a un jugador disminuir el valor de los aces en su mano hasta el mínimo posible en caso de que se encuentre en una posición de "desborde" del puntaje. Forma tentativa:

### `(try-changing-aces player current-score)`

La función trataría de evitar un desborde buscando todos los aces en posesión del jugador y conviertiéndolos a un valor de 1 en vez de un valor por defecto de 11.

## 11 de marzo:

- Se implementó la función que transforma los aces a un valor de uno en caso de que el puntaje del jugador se desborde.
- Se implementó también la lógica que maneja el cambio de turno cuando un jugador finaliza su turno.
- Se agregó una sección de código que inicializa todo as con un valor de 11, y se reducen automáticamente si el jugador se sobrepasa de un puntaje de 21.

## 14 de marzo:

- Este día se dedicó mayoritariamente a las pruebas de calidad del software. Falta implementar las pantallas de gane/pérdida, pero el resto del programa quedó funcionando como es de esperarse.
- Se corrigieron algunos errores menores. Uno, que se identificó como "greedy croupier" era un bug causado cuando el crupier se sobrepasa del 16 en su puntaje inicial, lo que causaba una cadena de problemas que resultaban en recursión infinita. Otros bugs arreglados involucraban tan solo algunos cambios de valores numéricos que por error causaban un cambio de valor de As incluso cuando no era conveniente (un blackjack por ejemplo). Para la resolución de los mismo fue esencial el trabajo en grupo, y fue una ventaja muy útil el hecho de que ambos integrantes estuvieran al tanto de el funcionamiento de las funciones implementadas por el otro. 

## 15 de marzo:

- Se trabajó mayoritariamente la documentación mientras el otro compañero refina ciertos elementos del juego y la lógica.
- Se realizó una reunión para coordinar la organización para esta semana final de desarrollo del proyecto. Se discutieron posibles mejoras al programa y se conversó sobre el desempeño como grupo de trabajo. 


## 16 de marzo

- Se agragó contenido vario a la documentación.
- Se confeccionaron los diagramas de la solución general y al algoritmo quicksort.
- Se confeccionó el Manual de usuario.
- Se realizaron pruebas de control de calidad para asegurar un buen funcionamiento del programa y su cumplimiento con la especificación dada.

## 17 de marzo

- Se confeccionaron algunos diagramas más (next-turn y try-changing-aces).
- Se expandió la documentación para agregar algunas conclusiones y recomendaciones.
- Se agregaron datos varios al manual de usuario.
- Se realizaron algunas medidas de desempeño para tomar datos de uso de memoria RAM para anotar dichos parámetros en el manual de usuario.
- Se discutió con el compañero sobre el cambio de una condicional que permitía que un 21 de usuario ganara a un 21 del croupier siempre y cuando tuviese menos cartas. La lógica se estableció que debía cambiarse para solo permitir eso en los casos en los que hay confirmado un blackjack, y no para cualquier situación en que el jugador tenga solo dos cartas.

## 18 de marzo

- Se agregó la guía de compilado al manual de usuario.
- Se agregaron algunas referencia faltantes a la documentación.
- Se agregó la documentación referente a los atajos de teclado.