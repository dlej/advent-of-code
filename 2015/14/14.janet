(def reindeer-grammar
  (peg/compile
    '{:line (group (* (<- :w+) " can fly " (number :d+) " km/s for " (number :d+) " seconds, but then must rest for " (number :d+) " seconds." :s+))
      :main (any :line)}))

(def speeds (table ;(catseq [[head & tail] :in (peg/match reindeer-grammar (slurp "14.txt"))] [head tail])))

(defn distance [name t]
  (let [[vel t-fly t-rest] (speeds name)
        t-tot (+ t-fly t-rest)
        rounds (div t t-tot)
        rem (mod t t-tot)
        t-fly-rem (min rem t-fly)]
    (+
      (* rounds (* vel t-fly))
      (* vel t-fly-rem))))

(def names (keys speeds))
(prin "part 1: ")
(pp (max-of (map |(distance $ 2503) names)))

(defn argmaxes [arr]
  (seq
    [:let [m (max-of arr)]
     i :range [0 (length arr)]
     :when (= m (arr i))]
    i))

(def scores (map (fn [x] 0) names))
(for i 0 2503
  (loop [:let [i (inc i)]
         k :in (argmaxes (map |(distance $ i) names))]
    (put scores k (inc (scores k)))))

(print "part 2: " (max-of scores))
