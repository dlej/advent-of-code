(def char-count-grammar
  (peg/compile '{:quote (/ "\"" (1 0))
                 :backslash (/ "\\\\" (2 1))
                 :esc-quote (/ "\\\"" (2 1))
                 :hex (/ (* "\\x" :h :h) (4 1))
                 :else (/ (if-not (+ :quote :backslash :esc-quote :hex :s) 1) (1 1))
                 :char (+ :quote :backslash :esc-quote :hex :else)
                 :main (any (+ :s :char))}))

(def char-counts (peg/match char-count-grammar (slurp "8.test")))

(pp (-
      (sum (map first char-counts))
      (sum (map last char-counts))))
