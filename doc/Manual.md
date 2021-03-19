---
title: Instituto Tecnológico de Costa Rica\endgraf\bigskip \endgraf\bigskip\bigskip\
 Tarea Corta 1 - BlaCEJack \endgraf\bigskip Manual de Usuario \endgraf\bigskip\bigskip


author: 
- José Morales Vargas 
- Alejandro Soto Chacón
  
date: \bigskip\bigskip\bigskip\bigskip Area Académica de\endgraf Ingeniería en Computadores \endgraf\bigskip\bigskip\ Lenguajes, Compiladores \endgraf e intérpretes (CE3104) \endgraf\bigskip\bigskip Profesor Marco Rivera Meneses \endgraf\vfill  Semestre I
header-includes:
- \setlength\parindent{24pt}

lang: es-ES
papersize: letter
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
\pagenumbering{arabic}
\setcounter{page}{1}

# 2.1. Requisistos de sistema:

- Instalación de intérprete de racket 8.0 en el sistema.
- 1 GB de Memoria RAM libre.
- 7,46 MB de espacio libre en disco duro.

# 2.2. Ambientes en los que se comprobó funcionamiento:

- Windows 10
- Arch Linux
- Manjaro Linux 

# 2.3. Reglas de juego:

- Cada jugador comienza con dos cartas.
- Cada turno un jugador puede escoger si plantarse o solicitar una carta.
- Si un jugador obtiene una puntuación que supera la del croupier sin pasarse de un valor sumado de 21, gana.
- Si un jugador se sobrepasa de un puntaje de 21 pierde.
- El croupier en su turno solicitará cartas hasta llegar a una puntuación de 17 o más.
- Si un jugador y el croupier obtienen el mismo puntaje, se considera empate
- Las cartas de As tienen un valor por defecto de 11, y su valor cambia convenientemente cuando el jugador se sobrepasa del 21.
- Las cartas de figuras suman 10 puntos cada una.
- Las cartas de valores numéricos suman su valor al puntaje.
- Un 21 producto de un blackjack gana sobre un 21 obtenido con suma de cartas comunes.
- Si un jugador se planta no puede tomar carta hasta terminar el juego. 

# 2.4. Inicio de Juego:


## Método 1: REPL

Para las instrucciones de inicio, entiéndase X como una variable ingresada por el usuario, la cuál indica la cantidad de jugadores que se desean tener en la partida.

Si se desea empezar el juego desde consola powershell en Windows:

```PowerShell
>set blackcejack=[carpeta del proyecto]
>%blackcejack%>cd src
>%blackcejack%\src>racket
```
```scheme
>(enter! "ui.rkt")
>(bCEj X)
```

En Linux el proceso difiere poco:
```Console
>export blackcejack=[carpeta del proyecto]
>$blackcejack$>cd src
>$blackcejack$/src>racket
```
```scheme
>(enter! "ui.rkt")
>(bCEj X)
```



Alternativamente se puede cargar el archivo ui.rkt en un programa como DrRacket o VSCode y cargar el archivo al REPL, eso sí, en dichos casos sigue siendo necesario ejecutar el comando de inicio de juego:

```scheme
>(bCEj X)
```

Ejecutado el comando, se mostrará una ventana inicial para ingresar los nombres de los jugadores a estar en la partida:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/startdialog.PNG)


## Método alternativo: ejecutable

Un ejecutable puede compilarse de los archivos fuente. Puede solicitar el mismo a los colaboradores del proyecto, o compilar el ejecutable usted mismo. Las instrucciones para el proceso de compilado se encuentran en la sección de anexos.

# 2.5. Interfaz:

Mientras se cargan los recursos del programa, se muestra una pantalla con imágenes conjuntos de carta que varían al azar con cada inicio de juego.

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/assets/splash/honor_spades.png)

Una vez cargado el juego se muestra la interfaz de juego:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/start-screen.PNG)

Los elementos de la misma se pueden dividir entre tres secciones. La primera sección es el tablero de información externa a los jugadores:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/croupier.png)

En esa sección se muestra el mazo y el estado del croupier, el cuál inicia con una carta boca abajo y solo le da la vuelta hasta que haya llegado el turno del croupier.

Seguidamente está el tablero de información para el jugador:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/cards.png)

En esta sección el o los jugadores pueden visualizar cuales cartas tienen en mano y cuál es su puntaje. Cuando un jugador se planta o se sobrepasa de 21, su nombre y puntaje son deshabilitados para mostrar que estos jugadores ya no se encuentran activos. 

Por último, está la sección de control de usuario.
En esta sección se muestra al jugador activo, y dos botones que le permiten decidir cual será su siguiente acción:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/player-actions.png)

El juego se desarrollará según lo especificado en la sección de reglas, hasta finalmente llegar a un estado final. El reporte de juego se presenta en una ventana de puntajes al finalizar una partida:

![](https://raw.githubusercontent.com/itcr3442/CE3104-BlaCEJack/master/doc/game-end.PNG)

Esta ventana final da la posibilidad de reiniciar el juego. Usar la opción "Quit" cerrará el programa, mientras que "Restart" permitirá comenzar una partida adicional desde el inicio con los mismos jugadores. Si se desea iniciar con otro set de jugadores, se deberá cerrar el programa e iniciarlo de nuevo con el parámetro de cantidad de jugadores deseado (ver sección de "Inicio de Juego").

## Atajos del teclado

Para disposición del jugador se habilitaron algunos atajos del teclado:

* **Alt+T**: Tomar carta
* **Alt+S**: Plantarse
* **Alt+R**: Restart
* **Alt+Q**: Quit

Estos atajos permiten facilitar las multipartidas pues se puede utilizar para para evitar que todos los jugadores deban usar los mismos controles. 

Con la ayuda de un microcontrolador con capacidades USB-HID podrían hacerse controles individuales que "inyecten" esta secuencia de teclas. Si el usuario quiere experimentar con esta posibilidad, se le recomienda utilizar algunos de los MCU's de la siguiente lista:

* Arduino Pro Micro
* STM32 Bluepill
* Teensy (cualquier versión es funcional, aunque se puede preferir una revisión más reciente)



# Anexo: Guía de compilación de ejecutable

## Windows

Para generar un ejecutable en windows es necesario tener disponible `make` en el sistema. Si bien hay varias maneras de conseguir `make`, en esta guía solo se cubrirá el uso de chocolatey. Se asume que el usuario ya tiene disponible la herramienta de git en sus sistema, de lo contrario, favor descargar git en el siguiente link antes de continuar: <https://git-scm.com/downloads>

1. Abrir una consola de PowerShell con permisos de administrador
2. Seguir los pasos indicados en <https://chocolatey.org/install>
3. Al finalizar la instalación de chocolatey, debe cerrar la consola creada anteriormente y abrir una nueva (otra vez con permisos de administrador).
4. Ejecutar:

```Powershell
>choco install make
```

5. Diríjase a una carpeta de su preferencia, haga `shift+click derecho` y seleccione "abrir ventana de powershell aquí".
6. Ejecute los siguientes comandos en la consola de Powershell:

```Console
>git clone https://github.com/itcr3442/CE3104-BlaCEJack.git
```

```Console
>cd CE3104-BlaCEJack
```

```Console
>make -p build
```

El ejecutable se debería encontrar listo para su uso dentro de la carpeta "build" en el directorio del repositorio clonado.  


## Linux

Dependiendo de la distribución y configuración inicial, es posible que ya `make` se encuentre instalado, para confirmar esto, ejecute el comando:

```Console
>make -v
```

Si el comando anterior da error o no comunica ninguna salida, debe instalar make primero, de manera general:

```Console
>sudo [administrador de paquetes] install make
```

En vez de "administrador de paquetes" debe escribir
* `apt` si su sistema está basado en Ubuntu
* `dnf` si es de la familia de sistemas de Fedora/Red Hat
* `pamac` si es manjaro

En Arch (y distros basadas en Arch como Manjaro), para conseguir make el comando cambia un poco:

```Console
>sudo pacman -S make
```

Una vez que tenga make en su sistema, busque la carpeta en la que quiere clonar el repositorio, abra una consola en ella y ejecute:

```Console
>git clone https://github.com/itcr3442/CE3104-BlaCEJack.git
```

```Console
>cd CE3104-BlaCEJack
```

```Console
>make -p build
```


El ejecutable se debería encontrar listo para su uso dentro de la carpeta "build" en el directorio del repositorio clonado. 