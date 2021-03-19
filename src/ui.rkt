#lang racket/base

#|______________________________________________________ 
ui.rkt: Interfaz de usuario de BlaCEJack.

Instituto Tecnológico de Costa Rica
Área Académica de Ingeniería en Computadores
Lenguajes, Compiladores e Intérpretes Grupo 02
Profesor: Marco Rivera Meneses
Estudiantes: José Fernando Morales Vargas - 2019024270
Alejandro José Soto Chacón - 2019008164
_______________________________________________________|#


(require racket/gui racket/runtime-path)
(require "logic.rkt")

(provide bCEj start-game ask-player-names)

(define-runtime-path assets-path "../assets")


#| Función bCEj
Descripción: Entrypoint de la aplicación, siendo player-count` es la cantidad
             de jugadores. La descripción de esta función y su prototipo se incluye en la
             especificación, por lo cual no debe modificarse.
Entradas:
- player-count: Número de jugadores, entero entre 1 y 3, ambos inclusive
Salida: `(void)`
Ejemplos de uso:
- >(bCEj 3)  ; Aparece la interfaz de usuario
|#
(define (bCEj player-count)
  (cond [(not (integer? player-count))
         (raise "Expected an integer numbe rof players")]

        [(or (< player-count 1) (> player-count 3))
         (raise "There may only be one, two, or three players")])

  (ask-player-names player-count start-game))


#| Función ask-player-names
Descripción: Pregunta al usuario por nombres de jugadores para un
             nuevo juego en un cuadro de diálogo.
Entradas:
- up-to: Número máximo de jugadores, entero positivo.
- then: Función que admita un único argumento con la lista de nombres
- allow-blanks (opcional): Si se indica `#t`, entonces se aceptarán
                           nombres en blanco. La lista pasada a `then`
                           estará filtrada de nombres en blanco. La
                           única restricción será que haya al menos
                           un nombre no vacío.
Salida: `(void)`
Ejemplos de uso:
- >(ask-player-names 3 start-game)
|#
(define (ask-player-names up-to then [allow-blanks #f])
  (let ([names-dialog (new dialog% [label "Player names"])])
    (when allow-blanks
      (new message%
           [parent names-dialog]
           [label "Players with blank names are ignored."]))

    (let ([name-fields (add-name-fields names-dialog up-to 1 empty)])
      (new button%
           [parent names-dialog]
           [label "Play"]
           [callback
             (λ (button event)
                (let*-values
                  ([(player-names)
                    (map (λ (field) (string-trim (send field get-value))) name-fields)]

                   [(player-names blanks)
                    (cond [allow-blanks
                            (values (filter non-empty-string? player-names)
                                    empty)]

                          [else (values player-names
                                        (filter (compose not non-empty-string?)
                                                player-names))])])

                  (when [and (empty? blanks) (not (empty? player-names))]
                    (send names-dialog show #f)
                    (start-game player-names))))]))

    (send names-dialog show #t)))


#| Función start-game
Descripción: Inicia una instancia del juego, mostrando una pantalla de splash
             mientras carga.
Entradas:
- player-names: Lista de al menos un nombre de jugador, debe ser una lista de cadenas.
Salida: `(void)`
Ejemplos de uso:
- >(start-game '("Foo" "Bar" "Baz"))
|#
(define (start-game player-names)
  (run-game player-names (splash-screen)))


#| Función splash-screen
Descripción: Genera y muestra una pantalla de carga con un fondo aleatorio.
Salida: El `gauge%` asociado a la barra de progreso, en un estado indefinido.
        El caller es responsable de definirle un rango e incrementarlo.
Ejemplos de uso:
- >(splash-screen)  ; A partir de aquí la pantalla de carga es visible
|#
(define (splash-screen)
  (let* ([splashes '("aces" "honor_clubs" "honor_diamonds" "honor_hearts" "honor_spades")]
         [splash (load-bitmap
                   (string-append "splash/" (list-ref splashes (random (length splashes)))))]

         [width (send splash get-width)]
         [height (send splash get-height)]

         [screen (new frame%
                      [label ""]
                      [style '(float no-resize-border no-caption no-system-menu)])]

         [pane (new vertical-pane% [parent screen])])

    (new canvas%
         [parent pane]
         [min-width (quotient width 3)]
         [min-height (quotient height 3)]
         [paint-callback
           (λ (canvas dc)

              (send dc set-scale (/ 1 3) (/ 1 3))
              (send dc draw-bitmap splash 0 0)

              (let*
                ([font (send the-font-list find-or-create-font 130 'default 'normal 'normal)]
                 [text-width (λ (text) (get-text-width dc text font))]

                 [bla (text-width "Bla")]
                 [ce (text-width "CE")]
                 [jack (text-width "Jack")]

                 [start-x (quotient (- width bla ce jack) 2)]
                 [start-y (quotient (* height 3) 4)]

                 [black (send dc get-text-foreground)]
                 [red (send the-color-database find-color "red")])

                (send dc set-font font)
                (send dc draw-text "Bla" start-x start-y)

                (send dc set-text-foreground red)
                (send dc draw-text "CE" (+ start-x bla) start-y)

                (send dc set-text-foreground black)
                (send dc draw-text "Jack" (+ start-x bla ce) start-y)))])

    (let ([gauge (new gauge%
                      [parent pane]
                      [label "Loading... "]
                      ; The real range will be set later
                      [range 1])])

      (send screen show #t)
      (yield)
      gauge)))


#| Función run-game
Descripción: Ejecuta una nueva partida de juego. Muestra la ventana
             principal de juego, coloca e inicializa elementos de interfaz,
             provoca las acciones iniciales del juego y determina la
             secuencia de desarrollo de la partida en función de subsecuentes
             cambios de estado. Al terminar la secuencia, acciona los procesos
             de puntaje y finalización/reinicio.
Entradas:
- player-names: Lista de al menos un nombre de jugador como cadenas de texto.
- splash-gauge (opcional): Barra de progreso de carga, a incrementar
                           conforme progresa la carga y cuya ventana
                           será eliminada al terminar la carga.
Salida: `(void)`
Ejemplos de uso:
- >(run-game '("Foo" "Bar" "Baz") (splash-screen))
  ; Muestra un splash mientras se inicia una nueva partida
|#
(define (run-game player-names [splash-gauge #f])
  (letrec
    ([window
       (new frame%
            [label "BlaCEJack"]
            [width 800]
            [height 600]
            [alignment '(center top)])]

     [top-row (new horizontal-panel% [parent window])]
     [game-table (new horizontal-panel% [parent window])]
     [bottom-panel (new horizontal-panel%
                        [parent window]
                        [alignment '(center center)])]

     [croupier-container (game-container top-row "Croupier")]
     [deck (game-container top-row "Deck" draw-deck 52)]

     [player-containers (map (curry game-container game-table) player-names)]
     [current-player
       (new message%
            [parent
              (new horizontal-pane%
                   [parent bottom-panel]
                   [alignment '(center center)])]

            [label (cdar (quicksort (map (λ (name) (cons (string-length name) name))
                                         player-names)
                                    (λ (a b) (> (car a) (car b)))))]

            [font (send the-font-list find-or-create-font 30 'default 'normal 'bold)])]

     [action-pane
       (new vertical-pane%
            [parent bottom-panel]
            [alignment '(left center)])]

     [action-button
       (λ (parameter label)
          (new button%
               [parent action-pane]
               [label label]
               [callback
                 (λ (button event)
                    (enable-action-buttons #f)
                    ((parameter)))]))]

     [on-stand-up (make-parameter #f)]
     [on-take-card (make-parameter 0)]

     [take-card-button (action-button on-take-card "&Take card")]
     [stand-up-button (action-button on-stand-up "&Stand")]

     [enable-action-buttons
       (λ (enable?)
          (send take-card-button enable enable?)
          (send stand-up-button enable enable?))]

     [do-turn
       (λ (game player-id player)
          (on-stand-up (λ () (rotate-player (stand game player-id) player-id)))
          (on-take-card
            (λ ()
               (rotate-player
                 (grab game deck (list-get player-containers player-id) player-id)
                 player-id)))

          (send current-player set-label (name player)))]

     [rotate-player
       (λ (game player-id)
          (when [not (active? (get-player game player-id))]
            (send (container-panel (list-get player-containers player-id)) enable #f))

          (match (next-turn game player-id)
                 [(list) ; No active players are left

                  (send bottom-panel show #f)
                  (end-of-game game deck croupier-container window
                               (λ (restart?)
                                  (send window show #f)
                                  (when restart? (run-game player-names))))]

                 [(cons next-id next)

                  (enable-action-buttons #t)
                  (do-turn game next-id next)]))])

    (send (container-panel croupier-container) enable #f)
    (send (score-label croupier-container) show #f)
    (send bottom-panel show #f)

    (when splash-gauge
      #| +1 for all operations that go before bitmap loading
      || +2 for 'hidden and 'large-stack
      || +52 for every other preloaded bitmap
      ||#
      (send splash-gauge set-range (+ 1 2 52))
      (load-progress splash-gauge))

    (preload-bitmaps splash-gauge)

    (when splash-gauge (send (send splash-gauge get-top-level-window) show #f))
    (send window show #t)

    (sleep/yield 0.5)

    (letrec
      ([initial-grab-for-players
         (λ (game containers player-ids)
            (cond [(empty? player-ids) game]
                  [else (initial-grab-for-players
                          (initial-grab game deck (car containers) (car player-ids))
                          (cdr containers) (cdr player-ids))]))]

       [empty-game (new-game player-names)]
       [game (initial-grab-for-players
               (initial-grab empty-game deck croupier-container 'croupier)
               player-containers (range (length (players empty-game))))])

      (do-turn game 0 (car (players game))))

    (send bottom-panel show #t)))


#| Función end-of-game
Descripción: Realiza acciones finales y termina una partida,
             mostrando la tabla de puntuaciones.
Entradas:
- game: Estado de juego hasta este punto.
- deck: Marco contenedor del mazo.
- croupier-container: Marco contenedor de juego del croupier.
- window: Ventana principal de juego.
- then: Véase parámetro `then` de `show-score`.
Salida: `(void)`
Ejemplos de uso:
- >(end-of-game ... (λ (restart?) ...))
|#
(define (end-of-game game deck croupier-container window then)
  (flip 0.25
    (λ ()
       (send (container-panel croupier-container) enable #t)
       (send (score-label croupier-container) show #t)
       (update-cards croupier-container
                     (shown-cards (reverse (held-cards (croupier game)))
                                  croupier-container 'croupier))))

  (letrec
    ([grab-last-croupier-cards
       (λ (game)
          (cond [(game-finished? game) game]
                [else (grab-last-croupier-cards
                        (grab game deck croupier-container 'croupier))]))])

    (show-score (grab-last-croupier-cards game) window then)))


#| Función show-score
Descripción: Muestra la tabla de puntuaciones y determina
             si el juego debe reiniciarse o finalizarse.
Entradas:
- game: Estado de juego hasta este punto.
- window: Ventana principal de juego, a como fue generada por `new-game`.
- then: Función que debe aceptar un único argumento booleano `restart?`,
        el cual determina si la decisión fue reiniciar o finalizar.
Salida: `(void)`
Ejemplos de uso:
- >(show-score game window (λ (restart?) #| acción posterior |#))
|#
(define (show-score game window then)
  (letrec
    ([dialog (new dialog%
                  [parent window]
                  [label "Scoreboard"])]

     [rows
       (append
         (list
           '("No." "Name" "Score" "Outcome")
           '("" "" "" "") ; Fake padding

           (list "" "Croupier"
                 (number->string (score (croupier game)))
                 (cond [(lost? (croupier game)) "Loses if player wins"]
                       [else ""])))

         (map
           (curry apply
                  (λ (position name score outcome)
                     (list (string-append "#" (number->string (+ position 1)))
                           name (number->string score)
                           (match outcome
                                  ['tie "Tie"]
                                  ['wins "Wins"]
                                  ['loses "Loses"]))))

           (scoreboard game)))]

     [column-widths
       (λ (dc)
          (map (λ (column)
                  (apply max
                         (map (compose (curry get-text-width dc)
                                       (λ (row) (list-ref row column)))

                              rows)))

               (range (length (car rows)))))]

     [draw-cell
       (λ (dc rows widths all-widths x-offset y-offset)
          (when [not (empty? rows)]
            (cond [(empty? (car rows))
                   (draw-cell dc (cdr rows) all-widths all-widths 0 (+ y-offset 15))]

                  [else (send dc draw-text (car (car rows)) x-offset y-offset)
                        (draw-cell dc (cons (cdr (car rows)) (cdr rows))
                                   (cdr widths) all-widths
                                   (+ x-offset (car widths) 20) y-offset)])))])

    (new canvas% 
         [parent dialog]
         [style '(transparent)]
         [min-height (* 20 (length rows))]
         [min-width
           (apply (compose exact-round +)
                  (map (curry + 20)
                       (column-widths (send (new canvas% [parent dialog]) get-dc))))]

         [paint-callback
           (λ (canvas dc)
              (let ([widths (column-widths dc)])
                (draw-cell dc rows widths widths 0 0)))])

    (let*
      ([bottom-row (new horizontal-pane%
                        [parent dialog]
                        [alignment '(center top)])]

       [final-action
         (λ (label restart?)
            (new button%
                 [parent bottom-row]
                 [label label]
                 [callback
                   (λ (button event)
                      (send dialog show #f)
                      (then restart?))]))])

      (final-action "&Restart" #t)
      (final-action "&Quit" #f)

      (send dialog show #t))))


#| Función get-text-width
Descripción: Determina el ancho que tendrá un fragmento de
             texto cuando sea renderizado.
Entradas:
- dc: Contexto de dibujo, instancia de `dc%`.
- text: Texto a medir, debe ser una cadena.
- font (opcional): Fuente contra la cual medir, instancia de
                   `font%`; por defecto se asume la fuente en uso
                   activo para `dc`.
Salida: Tamaño, medido en unidades base de dibujo, del texto cuando
        sea renderizado con la fuente en cuestión.
Ejemplos de uso:
- >(get-text-width dc "Jack")
  >>>52
|#
(define (get-text-width dc text [font #f])
  (call-with-values
     (λ () (send dc get-text-extent text font))
     (λ (width height baseline padding) width)))


#| Función add-name-fields
Descripción: Genera una lista de campos de texto para nombres de jugador
             a utilizada por `start-game`.
Entradas:
- dialog: Diálogo, instancia `dialog%`, al cual se agregarán los campos 
- up-to: Máximo número de jugador a incluir, entero positivo.
- next: Número del siguiente jugador por campo, inicialmente debe ser 1.
- fields: Campos ya generados, en orden inverso, para uso recursivo.
Salida: Los campos de texto insertados en respectivo orden, siendo
        cada uno instancia de `text-field%`.
Ejemplos de uso:
- >(add-name-fields dialog 3 1 empty)
  >>> (list #| tres campos de texto |#)
|#
(define (add-name-fields dialog up-to next fields)
  (cond
    [(> next up-to) (reverse fields)]
    [else
      (add-name-fields
        dialog
        up-to
        (+ next 1)
        (cons (new text-field%
               [parent dialog]
               [label
                 (string-append "Player #"
                                (number->string next))])
              fields))]))


#| Función game-container
Descripción: Crea un marco contenedor para un participante.
Entradas:
- parent: Elemento gráfico padre.
- name: Nombre del participante.
- custom-draw (opcional): Función que debe admitir llamadas de la
                          forma `(custom-draw canvas dc current-cards)`,
                          donde `canvas` y `dc` son los objetos típicamente
                          asociados a ambos nombres, y `current-cards`
                          es el estado actual en ese punto del parámetro
                          variable de cartas actuales. Si no se especifica
                          se asume `draw-stack`.
- initial-cards (opcional): Cartas iniciales bajo control de este
                            marco; se asume '() si no se especifica.
                            Puede ser un objeto arbitrario en caso
                            de presentarse `custom-draw`, de lo contrario
                            debe ser una lista de cartas.
Salida: Un marco contenedor visible bajo `parent`,
        manipulable a través de `container-label`,
        `score-label`, `card-canvas` y `current-cards`.
        Si no se especificó `custom-draw`, se colocará
        una etiqueta con puntuación nula automáticamente.
Ejemplos de uso:
- >(game-container window "Foo")
|#
(define (game-container parent name [custom-draw #f] [initial-cards '()])
  (let*
    ([panel (new vertical-panel% [parent parent])]
     [name-label (new message% [parent panel] [label name])]
     [score-label
       (new message%
            [parent panel]
            [label ""]
            [auto-resize #t])]

     [current-cards (make-parameter initial-cards)]
     [card-canvas
       (new canvas%
            [parent panel]
            [style '(border transparent)]
            [paint-callback
              (λ (canvas dc)
                 ((or custom-draw draw-stack)
                  canvas dc (current-cards)))])]

     [container (list panel score-label card-canvas current-cards)])

    (when [not custom-draw] (update-score container 0))
    container))


#| Función container-panel
Descripción: Obtiene el panel que engloba un marco contenedor.
Entradas:
- container (implícita): Marco contenedor.
Salida: Instancia de `vertical-panel%` padre de todo el marco.
Ejemplos de uso:
- >(container-panel croupier-container)
|#
(define container-panel car)


#| Función score-label
Descripción: Obtiene la etiqueta de puntaje de un marco contenedor.
Entradas:
- container (implícita): Marco contenedor.
Salida: Instancia de `message%` que muestra la puntuación actual.
Ejemplos de uso:
- >(score-label croupier-container)
|#
(define score-label cadr)


#| Función score-label
Descripción: Obtiene el lienzo de un marco contenedor donde se
             dibujan las cartas del participante.
Entradas:
- container (implícita): Marco contenedor.
Salida: Instancia de `canvas%`.
Ejemplos de uso:
- >(card-canvas croupier-container)
|#
(define card-canvas caddr)


#| Función current-cards
Descripción: Obtiene el parámetro variable de cartas de un
             marco contenedor.
Entradas:
- container (implícita): Marco contenedor.
Salida: Función que al llamarse con aridad cero se comporta
        como un getter de cartas actuales, y al invocarse
        con un argumento se comporta como setter.
Ejemplos de uso:
- >((current-cards croupier-container) '((5 hearts) (9 diamonds)))
|#
(define current-cards cadddr)


#| Función initial-grab
Descripción: Toma cartas para un participante hasta que las reglas
             de juego indiquen que está listo para iniciar.
Entradas:
- game: Estado de juego hasta el momento.
- deck: Marco contenedor del mazo.
- container: Marco contenedor del participante.
- player-id: Índice de jugador, o `'croupier`.
Salida: El estado de juego una vez tomadas las cartas iniciales del participantes.
Ejemplos de uso:
- >(length
     (taken-cards
       (croupier (initial-grab (new-game "Foo") deck croupier-container 'croupier))))
  >>> 2
|#
(define (initial-grab game deck container player-id)
  (cond [(ready? (get-player game player-id)) game]
        [else (initial-grab (grab game deck container player-id)
                            deck container player-id)]))


#| Función grab
Descripción: Transfiere una carta del mazo hacia un participante,
             realizando las acciones, animaciones y efectos de
             interfaz que esto implique.
Entradas:
- game: Estado de juego hasta el momento.
- deck: Marco contenedor del mazo.
- container: Marco contenedor del participante.
- player-id: Índice del jugador participante, o `'croupier`.
Salida: Nuevo estado de juego
Ejemplos de uso:
- >(grab game deck croupier-container 'croupier)
  ; El croupier adquiere una carta más en su mano
|#
(define (grab game deck container player-id)
  (match (take-card game)
         [(cons card game)
          (let*
            ([game (put-card game player-id card)]
             [player (get-player game player-id)]

             [cards (shown-cards (reverse (held-cards player))
                                 container player-id)]

             [cards-in-deck (- 52 (length (taken-cards game)))])

            (flip 0.05
              (λ ()
                 (animate-deck-grab (card-canvas deck) cards-in-deck)

                 (update-cards deck cards-in-deck)
                 (update-cards container cards)
                 (update-score container (score player))))

            game)]))


#| Función animate-deck-grab
Descripción: Dibuja rápidamente varias versiones del mazo
             en donde la última carta se desplaza progresivamente
             a la derecha, otorgando una impresión de movimiento.
Entradas:
- canvas: Lienzo de dibujo del mazo.
- remaining: Lista de cartas que sobrarán una vez que la última
             carta ya no sea visible.
Salida: `(void)`
Ejemplos de uso:
- >(animate-deck-grab deck 51)
  ; Sale la carta superior de un mazo completo
|#
(define (animate-deck-grab canvas remaining)
  (define (do-frame dc steps)
    (when [< steps 3]

      (send dc suspend-flush)
      (send dc erase)

      (draw-deck canvas dc remaining (* 0.1 (+ steps 2)))
      (send dc resume-flush)

      (sleep/yield 0.005)
      (do-frame dc (+ steps 1))))

  (let ([dc (send canvas get-dc)])
    (do-frame dc 0)))


#| Función shown-cards
Descripción: Transforma una lista de cartas de participante
             en una lista de cartas a mostrar, posiblemente
             reemplazando la primera con lo que gráficamente
             es una carta oculta.
Entradas:
- all-cards: Todas las cartas del participante descubiertas.
- container: Marco contenedor del participante.
- player-id: Índice del jugador participante, o `'croupier`.
Salida: Una lista de cartas, donde si alguna carta fue
        ocultada será reemplaza con `'hidden`.
Ejemplos de uso:
- >(shown-cards (cards (croupier game)) croupier-container 'croupier)
  >>>'('hidden ...)
|#
(define (shown-cards all-cards container player-id)
  (cond [(or (empty? all-cards)
             (not (eqv? player-id 'croupier))
             (send (container-panel container) is-enabled?))

         all-cards]

        [else (cons 'hidden (cdr all-cards))]))


#| Función flip
Descripción: Reproduce asíncronamente un efecto de toma de
             carta mientras ejecuta una acción con un tiempo
             de retardo final.
Entradas:
- container: Marco contenedor del participante.
- duration: Duración de retardo, real positivo.
- action: Una función de aridad cero.
Salida: `(action)`
Ejemplos de uso:
- >(flip 0.25 (λ () ...))
  ; Se actualiza visualmente la puntuación
|#
(define (flip duration action)
  (play-sound (build-path assets-path "card-flip.wav") #t)
  (let ([output (action)])
    (sleep/yield duration)
    output))


#| Función update-score
Descripción: Actualiza los elementos gráficos asociados a la
             puntuación de un participante de juego.
Entradas:
- container: Marco contenedor del participante.
- score: Nueva puntuación, entero no negativo.
Salida: `(void)`
Ejemplos de uso:
- >(update-score croupier-container 17)
  ; Se actualiza visualmente la puntuación
|#
(define (update-score container score)
  (send (score-label container) set-label
        (string-append "Score: " (number->string score))))


#| Función update-cards
Descripción: Actualiza las cartas actuales de un marco contenedor.
Entradas:
- container: Marco contenedor para el que se actualizarán sus cartas.
- cards: Nuevas cartas, aceptando el tipo esperado por la función
         responsable de dibujar este marco en cuestión, por lo cual
         no necesariamente es una lista de cartas (véase el parámetro
         `custom-draw` de la función `game-container`).
Salida: `(void)`
Ejemplos de uso:
- >(update-cards container (taken-cards (car (players game))))
|#
(define (update-cards container cards)
  ((current-cards container) cards)
  (send (card-canvas container) refresh-now))


#| Función draw-stack
Descripción: Dibuja las cartas en manos de un participante.
Entradas:
- canvas: Lienzo de dibujo.
- dc: Contexto de dibujo.
- cards: Lista de cartas a dibujar.
Salida: `(void)`
Ejemplos de uso:
- >(draw-stack canvas dc '((5 hearts) (9 pikes)))
|#
(define (draw-stack canvas dc cards)
  (letrec 
    ([spacing (λ (bitmap) (quotient (send bitmap get-width) 4))]
     [draw-stack
       (λ (offset cards)
          (when [not (empty? cards)]
            (let*
              ([bitmap (card-bitmap (car cards))]
               [scale (fitting-scale canvas bitmap)])

              (send dc set-scale scale scale)
              (send dc draw-bitmap bitmap offset 0)

              (draw-stack (+ offset (spacing bitmap)) (cdr cards)))))]

     #| We want a centered card stack, therefore:
     || base-offset = canvas-width/2 - stack-width/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-width))/2
     ||             = (canvas-width - ((n - 1) * card-spacing + card-spacing * 4))/2
     ||             = (real-canvas-width/scale - (n + 3) * card-spacing)/2
     |#
     [base-offset
       (when [not (empty? cards)]
         (/ (- (/ (send canvas get-width)
                  (fitting-scale canvas (card-bitmap (car cards))))

               (* (+ (length cards) 3)
                  (spacing (card-bitmap (car cards)))))
            2))])

    (draw-stack base-offset cards)))


#| Función draw-deck
Descripción: Dibuja el mazo, posiblemente con un corrimiento de animación.
Entradas:
- canvas: Lienzo de dibujo.
- dc: Contexto de dibujo.
- count: Número de cartas en el mazo, sin contar la desplazada.
- swipe-factor (opcional): Fracción que indica qué tanto debe
                           mostrarse desplazada la última carta
                           del mazo, medida en unidades del
                           ancho de una carta.
Salida: `(void)`
Ejemplos de uso:
- >(draw-deck canvas dc 52)      ; Dibuja un mazo completo
- >(draw-deck canvas dc 51 0.5)  ; Igual, pero desplaza la última carta
|#
(define (draw-deck canvas dc count [swipe-factor 0])
  (when [> count 0]
    (let* ([many-cards (card-bitmap 'large-stack)]
           [hidden (card-bitmap 'hidden)]

           [width (send many-cards get-width)]
           [height (send many-cards get-height)]
           ; Should be the same for 'hidden
           [scale (fitting-scale canvas many-cards)]

           [swipe-unit (send hidden get-width)]
           [spacing (round (/ swipe-unit 32))]
           [crop-width (* spacing (- count 1))]
           [joint (- width (* spacing 51))])

      (send dc set-scale scale scale)

      (send dc draw-bitmap-section many-cards 0 0 0 0 crop-width height)
      (send dc draw-bitmap-section many-cards
            crop-width 0 (- width joint) 0 joint height)

      (let
        ([draw-hidden
           (λ (displacement)
              (send dc draw-bitmap hidden (+ crop-width joint displacement) 0))])

        (draw-hidden 0)
        (when [not (zero? swipe-factor)]
          (draw-hidden (* swipe-factor swipe-unit)))))))


#| Función card-bitmap
Descripción: Asocia una carta con su bitmap. Si la carta se encuentra
             cargada, la operación será inmediata. De lo contrario,
             ocurrirá una carga de almacenamiento secundario y un
             proceso de decodificación de duración corta pero notable.
Entradas:
- card: Carta para la cual se busca un bitmap.
Salida: De tener éxito, una instancia de `bitmap%`.
Ejemplos de uso:
- >(card-bitmap '(queen pikes))
  >>> #| bitmap de una reina de espadas |#
|#
(define (fitting-scale canvas bitmap)
  (/ (send canvas get-height) (send bitmap get-height)))


#| Función card-bitmap
Descripción: Asocia una carta con su bitmap. Si la carta se encuentra
             cargada, la operación será inmediata. De lo contrario,
             ocurrirá una carga de almacenamiento secundario y un
             proceso de decodificación de duración corta pero notable.
Entradas:
- card: Carta para la cual se busca un bitmap.
Salida: De tener éxito, una instancia de `bitmap%`.
Ejemplos de uso:
- >(card-bitmap '(queen pikes))
  >>> #| bitmap de una reina de espadas |#
|#
(define (card-bitmap card)
  (cond
    [(hash-has-key? loaded-bitmaps card) (hash-ref loaded-bitmaps card)]
    [else
      (let*
        ([value
           (match (card-value card)
                  [(or 1 11) "A"]
                  ['jack "J"]
                  ['queen "Q"]
                  ['king "K"]
                  [_ (number->string (card-value card))])]

         [symbol
           (match (card-symbol card)
                  ['pikes "S"]
                  ['hearts "H"]
                  ['clovers "C"]
                  ['diamonds "D"])]

         [bitmap (load-bitmap (string-append "cards/" value symbol))])

        (hash-set! loaded-bitmaps card bitmap)
        bitmap)]))


#| Función load-bitmap
Descripción: Carga y decodifica un bitmap a partir del directorio de recursos.
Entradas:
- path: Ruta al bitmap, relativa a la raíz de recursos, sin extensión.
Salida: De tener éxito, una instancia de `bitmap%`.
Ejemplos de uso:
- >(load-bitmap "cards/5D")
  >>> #| bitmap de un 5 de rombos |#
|#
(define (load-bitmap path)
  (read-bitmap (build-path assets-path (path-add-extension path ".png")) 'png))


; Bitmaps que ya han sido cargados en memoria
(define loaded-bitmaps (make-hash))


#| Función preload-bitmaps
Descripción: Precarga en memoria y decodifica los bitmaps que
             la aplicación requerirá, con tal de evitar pausas
             durante la ejecución mientras estos se cargan.
Entradas:
- gauge (opcional): Barra de progreso a incrementar mientras
                    se procesan bitmaps.
Salida: `(void)`.
Ejemplos de uso:
- >(load-bitmaps)  ; Durará algunos segundos
|#
(define (preload-bitmaps [gauge #f])
  (letrec
    ([special-bitmap
       (λ (key asset)
          (when [not (hash-has-key? loaded-bitmaps key)]
            (hash-set! loaded-bitmaps key (load-bitmap asset)))

          (load-progress gauge))]

     [preload-bitmaps
       (λ (cards)
          (when [not (empty? cards)]
            (yield)
            (card-bitmap (car cards))

            (load-progress gauge)
            (preload-bitmaps (cdr cards))))])

    (special-bitmap 'hidden "cards/red_back")
    (special-bitmap 'large-stack "cards/many")

    (preload-bitmaps (cartesian-product '(1 2 3 4 5 6 7 8 9 10 jack queen king 11)
                                        '(pikes hearts clovers diamonds)))))


#| Función load-progress
Descripción: Incrementa una barra de progreso de carga.
Entradas:
- gauge: Barra de progreso, o `#f`; en el último caso no se realiza acción.
Salida: `(void)`.
Ejemplos de uso:
- >(load-progress gauge)
  ; Visualmente, la barra de progreso avanza en una unidad
|#
(define (load-progress gauge)
  (when gauge
    (send gauge set-value (min (+ 1 (send gauge get-value)) (send gauge get-range)))))
