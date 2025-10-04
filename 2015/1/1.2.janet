(def floor-grammar (peg/compile
                     '{:paren (+ "(" ")")
                       :main (some (<- :paren))}))

(defn find-first-basement [line &opt pos floor]
  (default pos 0)
  (default floor 0)
  (let [x (match (line pos) "(" 1 ")" -1)
        pos (inc pos)
        floor (+ floor x)]
    (if (> 0 floor) pos (find-first-basement line pos floor))))

(loop [line :in (string/split "\n" (slurp "1.txt"))]
  #(print line)
  (print (find-first-basement (peg/match floor-grammar line))))
