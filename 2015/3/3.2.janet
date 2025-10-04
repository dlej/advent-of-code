(def moves-grammar (peg/compile
                     '{:dir (<- (+ "^" "v" "<" ">"))
                       :main (some :dir)}))

(def move-map {"<" '(-1 0)
               "^" '(0 1)
               ">" '(1 0)
               "v" '(0 -1)})

(defn go [pos move]
  (let [[x y] pos
        [dx dy] move]
    (tuple (+ x dx) (+ y dy))))

(defn count-houses [moves]
  (var pos-santa '(0 0))
  (var pos-robo '(0 0))
  (var visited @{pos-santa 2})
  (loop [i :range [0 (length moves)]
         :let [move (moves i)
               dir (move-map move)]]
    (if (even? i)
      (do (set pos-santa (go pos-santa dir))
        (put visited pos-santa (inc (get visited pos-santa 0))))
      (do (set pos-robo (go pos-robo dir))
        (put visited pos-robo (inc (get visited pos-robo 0))))))
  (length visited))

(loop [line :in (string/split "\n" (slurp "3.txt"))
       :let [moves (peg/match moves-grammar line)]
       :when moves]
  (print (count-houses moves)))
