(def number-grammar
  (peg/compile
    '{:number (number (* (? "-") :d+))
      :not-number (if-not :number 1)
      :main (some (+ :number :not-number))}))

(pp (sum (peg/match number-grammar (slurp "12.txt"))))
