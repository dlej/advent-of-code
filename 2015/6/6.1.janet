(def instructions-grammar
  (peg/compile
    '{:cmd (+
             (/ "turn off" :turn-off)
             (/ "turn on" :turn-on)
             (/ "toggle" :toggle))
      :pos (group (* (number :d+) "," (number :d+)))
      :line (group (* :cmd :s+ :pos :s+ "through" :s+ :pos :s+))
      :main (some :line)}))

(var lights
  (seq [i :range [0 1000]]
    (seq [i :range [0 1000]] 0)))

(loop [[cmd [i1 j1] [i2 j2]] :in (peg/match instructions-grammar (slurp "6.txt"))
       i :range-to [i1 i2]
       j :range-to [j1 j2]]
  (put (lights i) j
       (match cmd
         :turn-off 0
         :turn-on 1
         :toggle (- 1 ((lights i) j)))))

(pp (sum (map sum lights)))
