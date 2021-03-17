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

# Requisistos de sistema:

- Instalación de intérprete de racket 8.0 en el sistema.

# Sistemas operativos probados:

- Windows 10
- Arch Linux

# Inicio de Juego:

Si se desea empezar el juego desde consola powershell en Windows:

```PowerShell
set blackcejack=[carpeta del proyecto]
%blackcejack%>cd src
%blackcejack%\src>racket
```
```scheme
>(enter! "ui.rkt")
>(bCEj [numero de jugadores])
```

Alternativamente se puede cargar el archivo ui.rkt en un programa como DrRacket o VSCode y cargar el archivo al REPL, eso sí, en dichos casos sigue siendo necesario ejecutar los comandos de inicio de juego:

```scheme
>(enter! "ui.rkt")
>(bCEj [numero de jugadores])
```

# Controles:



# Reglas: