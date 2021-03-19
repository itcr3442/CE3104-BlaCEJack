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
classoption: fleqn
geometry: margin=1in
fontfamily: noto
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
```Bash
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

# Anexo: Guía de compilación de ejecutable

## Windows

Para generar un ejecutable en windows es necesario tener disponible make en el sistema. Si bien hay varias maneras de conseguir make, en esta guía solo se cubrirá el uso de chocolatey.

1. Abrir una consola de PowerShell con permisos de administrador
2. Si `Get-ExecutionPolicy` retorna `Restricted`, ejecutar `Set-ExecutionPolicy Bypass -Scope Process`
3. Instalar chocolatey usando el siguiente comando:

```Powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

4. Al finalizar la instalación de chocolatey, debe cerrar la consola creada anteriormente y abrir una nueva (otra vez con permisos de administrador).
5. Ejecutar:

```Powershell
choco install make
```



## Linux