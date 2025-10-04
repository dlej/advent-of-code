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
  (var pos '(0 0))
  (var visited @{pos 1})
  (loop [move :in moves
         :let [dir (move-map move)]]
    (set pos (go pos dir))
    (put visited pos (inc (get visited pos 0))))
  (length visited))

(loop [line :in (string/split "\n" (slurp "3.txt"))
       :let [moves (peg/match moves-grammar line)]
       :when moves]
  (print (count-houses moves)))
