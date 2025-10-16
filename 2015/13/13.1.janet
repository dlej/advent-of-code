(def relationship-grammar
  (peg/compile
    ~{:gain-lose (+ (* "gain " (number :d+)) (/ (* "lose " (number :d+)) ,-))
      :line (group (* (<- :a+) " would " :gain-lose " happiness units by sitting next to " (<- :a+) "." :s*))
      :main (some :line)}))


(def relationships-raw (peg/match relationship-grammar (slurp "13.txt")))

(def happy-map @{})
(defn get-happy [a b &opt dflt]
  (default dflt 0)
  (get happy-map (tuple ;(sorted [a b])) dflt))

(defn put-happy [a b val]
  (put happy-map (tuple ;(sorted [a b])) val))

(loop [line :in relationships-raw
       :let [[a points b] line]]
  (put-happy a b (+ (get-happy a b) points)))

(def names (keys (table ;(catseq [name :in (catseq [k :keys happy-map] k)] [name 0]))))

### borrowed from https://github.com/MikeBeller/janet-cookbook?tab=readme-ov-file#example-generator-of-permutations
(defn swap [a i j]
  (def t (a i))
  (put a i (a j))
  (put a j t))

(defn permutations [items]
  (fiber/new (fn []
               (defn perm [a k]
                 (if (= k 1)
                   (yield (tuple/slice a))
                   (do (perm a (- k 1))
                     (for i 0 (- k 1)
                       (if (even? k)
                         (swap a i (- k 1))
                         (swap a 0 (- k 1)))
                       (perm a (- k 1))))))
               (perm (array/slice items) (length items)))))
### end from

(defn total-happy [arrangement]
  (var total 0)
  (for i 0 (length arrangement)
    (+= total (if (< i (dec (length arrangement)))
                (get-happy (arrangement i) (arrangement (inc i)))
                (get-happy (arrangement i) (arrangement 0)))))
  total)

(prin "part 1: ")
(pp (max-of (seq [perm :in (permutations names)] (total-happy perm))))

(loop [name :in names]
  (put-happy name "Me" 0))
(array/push names "Me")
(prin "part 2: ")
(pp (max-of (seq [perm :in (permutations names)] (total-happy perm))))
