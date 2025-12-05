(def [ranges ids]
  (peg/match
    '{:range (group (* (number :d+) "-" (number :d+) :s))
      :main (* (group (some :range))
               :s*
               (group (some (* (number :d+) :s*))))}
    (slurp "input")))

(def ranges
  (let [rs @[]]
    (loop [[a b] :in (sorted (map |(tuple ;$) ranges))]
      (if (empty? rs) (array/push rs [a b])
        (let [[i j] (last rs)
              a- (max (inc j) a)]
          (if (<= a- b)
            (array/push rs [a- b])))))
    rs))

(defn fresh? [n]
  (prompt :result
    (loop [[a b] :in ranges]
      (if (and (<= a n) (<= n b))
        (return :result true)))
    false))

(print "part 1: " (count fresh? ids))
(print "part 2: " (sum (map (fn [[a b]] (inc (- b a))) ranges)))
