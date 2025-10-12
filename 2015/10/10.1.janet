(def look-say-grammar
  (peg/compile
    '{:digits (<- (* (only-tags (<- :d :dig)) (any (backmatch :dig))))
      :main (some :digits)}))

(defn look-say [str]
  (string/join
    (catseq [digits :in (peg/match look-say-grammar str)
             :let [dig (string/slice digits 0 1)
                   n (length digits)]]
            [(string/format "%d" n) dig])))

(def input-grammar
  (peg/compile
    '{:main (* (<- :d+) :s (number :d+))}))

(var [digits n] (peg/match input-grammar (slurp "10.txt")))
(for i 0 n
  (set digits (look-say digits)))

(pp (length digits))
