(def floor-grammar (peg/compile
                     '{:paren (+ "(" ")")
                       :main (some (<- :paren))}))

(defn count-up-down [line]
  (sum (map |(match $ "(" 1 ")" -1) line)))

(loop [line :in (string/split "\n" (slurp "1.txt"))]
  #(print line)
  (print (count-up-down (peg/match floor-grammar line))))
