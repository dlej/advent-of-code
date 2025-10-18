(def containers
  (peg/match
    '{:main (some (* (number :d+) :D*))}
    (slurp "17.txt")))
(def volume 150)

(defn fill-containers [volume containers]
  (fiber/new (fn []
               (if (= volume 0)
                 (yield @[])
                 (let [[head & tail] containers]
                   (if (empty? tail)
                     (if (= head volume) (yield @[head]))
                     (do
                       (loop [filling :in (fill-containers volume tail)]
                         (yield filling))
                       (if (<= head volume)
                         (loop [filling :in (fill-containers (- volume head) tail)]
                           (yield (array/concat @[head] filling)))))))))))

(def fillings (map identity (fill-containers volume containers)))

(prin "part 1: ")
(pp (length fillings))

(def min-length (min-of (map length fillings)))
(prin "part 2: ")
(pp (length (filter |(= (length $) min-length) fillings)))
