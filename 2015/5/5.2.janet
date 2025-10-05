(def twice-no-overlap
  (peg/compile
    '{:main (* (<- (2 :a)) (any (* (! (backmatch)) :a)) (backmatch))}))

(def one-letter-between
  (peg/compile
    '{:main (* (<- :a) :a (backmatch))}))

(defn nice [str]
  (and (truthy? (peg/find twice-no-overlap str))
       (truthy? (peg/find one-letter-between str))))

(pp
  (sum
    (seq [line :in (string/split "\n" (slurp "5.txt"))
          :when (not (empty? line))]
      (if (nice line) 1 0))))
