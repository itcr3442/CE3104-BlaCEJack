#lang racket/base

(require rackunit)
(require "logic.rkt")

(check-equal? (list-get '(1 2 3 4) 2) 3 "list indexing")

(check-equal? (quicksort '(2 3 4 1 1 2 5) <) '(1 1 2 2 3 4 5) "increasing quicksort")
(check-equal? (quicksort '(2 3 4 1 1 2 5) >) '(5 4 3 2 2 1 1) "decreasing quicksort")

(check-equal? (card-value '(queen diamonds)) 'queen "(card-value)")

(check-equal? (card-symbol '(queen diamonds)) 'diamonds "(card-symbol)")

(check-equal? (length (car (take-card (new-game '())))) 2 "(take-card) format")

(check-equal? (name '("Foo" active ((3 clovers)(5 diamonds)))) "Foo" "(name)")

(check-equal? (held-cards '("Foo" active ((3 clovers)(5 diamonds))))
              '((3 clovers)(5 diamonds))
              "(held-cards)")

(check-equal? (active? '("Foo" active ())) #t "(active?) for an active player")
(check-equal? (active? '("Bar" stood ())) #f "(active?) for a player who has stood")

(check-equal? (lost? '("Foo" lost ())) #t "(lost?) for a player who has lost")
(check-equal? (lost? '("Bar" active ())) #f "(lost?) for an active player")

(check-equal? (has-stood? '(croupier stood ()))
              #t
              "(has-stood?) for a player who has stood")
(check-equal? (has-stood? '("Bar" active ()))
              #f
              "(has-stood?) for an active player")

(check-equal? (ready? '("Foo" active ())) #f "(ready?) for a player with no cards")
(check-equal? (ready? '("Foo" active ((4 clovers) (3 hearts))))
              #t
              "(ready?) for a player with two cards")

(define game1 (cdr (take-card (cdr (take-card (new-game '("Foo" "Baz")))))))

(check-equal? (croupier game1) '(croupier active ()) "(croupier)")

(check-equal? (length (taken-cards game1)) 2 "(taken-cards)")

(check-equal? (get-player game1 'croupier)
              '(croupier active ())
              "(get-player) for 'croupier")
(check-equal? (get-player game1 1)
              '("Baz" active ())
              "(get-player) for non-croupier player")

(check-equal? (score '("Foo" active ((3 pikes) (4 hearts) (5 diamonds))))
              12
              "(score) for a player with some cards")

(define game2 (new-game '("Foo" "Bar" "Baz")))
(check-equal? (stand game2 0)
              '((("Foo" stood ()) ("Bar" active ()) ("Baz" active ()))
                (croupier active ()) ())
              "(stand) the first player")
(check-equal? (stand game2 1)
              '((("Foo" active ()) ("Bar" stood ()) ("Baz" active ()))
                (croupier active ()) ())
              "(stand) a second player")
(check-equal? (stand game2 2)
              '((("Foo" active ()) ("Bar" active ()) ("Baz" stood ()))
                (croupier active ()) ())
              "(stand) a third player")
(check-equal? (stand game2 'croupier)
              '((("Foo" active ()) ("Bar" active ()) ("Baz" active ()))
                (croupier stood ()) ())
              "(stand) the croupier")

(define game3 (new-game '("Foo" "Bar" "Baz")))
(check-equal? (put-card game3 'croupier '(3 clovers))
              '((("Foo" active ()) ("Bar" active ()) ("Baz" active ()))
                (croupier active ((3 clovers))) ())
              "(put-card) into a new game")

(define game4 (new-game '("Foo" "Bar" "Baz")))
(check-equal? (next-turn game4 1) '(2 "Baz" active ()) "(next-turn)")

(check-equal? (new-game '("Foo" "Bar"))
              '((("Foo" active ()) ("Bar" active ()))
                (croupier active ()) ())
              "(new-game) with two players")

(define game5 '((("Foo" stood ())
                 ("Bar" stood ((9 hearts) (7 pikes)))
                 ("Baz" lost ((10 diamonds) (7 hearts) (10 pikes))))
                (croupier lost ((9 clovers) (6 diamonds) (7 pikes))) ()))

(check-equal? (game-finished? game5) #t "(game-finished?) on end-of-game condition")

(check-equal? (players game5)
              '(("Foo" stood ())
                ("Bar" stood ((9 hearts) (7 pikes)))
                ("Baz" lost ((10 diamonds) (7 hearts) (10 pikes))))
              "(players)")

(check-equal? (scoreboard game5)
              '((0 "Baz" 17 loses)
                (1 "Bar" 16 wins)
                (2 "Foo" 0 wins))
              "(scoreboard) for a finished game")

(check-equal? (quicksort (players game5) (lambda (a b) (> (score a) (score b))))
              '(("Baz" lost ((10 diamonds) (7 hearts) (10 pikes)))
                ("Bar" stood ((9 hearts) (7 pikes)))
                ("Foo" stood ()))
              "scoreboard-style (quicksort)")
