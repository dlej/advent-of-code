(def char-count-grammar
  (peg/compile '{:quote (* (! "\"\n") (/ "\"" (1 2)))
                 :backslash (/ "\\" (1 2))
                 :else (/ :w (1 1))
                 :char (+ :quote :backslash :else)
                 :line (* (/ "\"" (1 3)) (any :char) (/ "\"" (1 3)) "\n")
                 :main (any :line)}))

(def char-counts (peg/match char-count-grammar (slurp "8.txt")))

(pp (-
      (sum (map last char-counts))
      (sum (map first char-counts))))
