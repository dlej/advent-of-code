(use spork)
(import spork/math)

(def ingredients
  (math/trans (peg/match
                ~{:non-digit-nl (if-not (+ "-" :d "\n") 1)
                  :num (number (* (? "-") :d+))
                  :main (some (group
                                (* (some (* (any :non-digit-nl) :num)) (any :non-digit-nl) "\n")))}
                (slurp "15.txt"))))

(def ingredients-sans-calories
  (seq [i :range [0 4]] (ingredients i)))
(def calories (ingredients 4))

(defn score [tsps]
  (->> (math/mul ingredients-sans-calories (array ;tsps))
       (math/squeeze)
       (map |(if (< 0 $) $ 0))
       (product)))

(defn iter-tsps [total ways]
  (fiber/new
    (fn []
      (if (= ways 1)
        (yield @[total])
        (for i 0 (inc total)
          (loop [tsps :in (iter-tsps (- total i) (dec ways))]
            (yield (array/concat @[i] tsps))))))))

(prin "part 1: ")
(-> (map score (iter-tsps 100 (length calories)))
    (max-of)
    (pp))

(prin "part 2: ")
(->> (seq [tsps :in (iter-tsps 100 (length calories))
           :when (= 500 (math/dot tsps calories))]
       tsps)
     (map score)
     (max-of)
     (pp))
