(def dists-grammar
  (peg/compile
    '{:place (<- :w+)
      :line (group (* :place " to " :place " = " (number :d+) :s+))
      :main (any :line)}))

(defn build-dists-map [dists-lines]
  (let [dists-map @{}]
    (loop [line :in dists-lines
           :let [[a b dist] line]]
      (unless (in dists-map a) (put dists-map a @{}))
      (unless (in dists-map b) (put dists-map b @{}))
      (put (get dists-map a) b dist)
      (put (get dists-map b) a dist))
    dists-map))

(defn nget [ds i j]
  (get (get ds i) j))

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

(defn path-dist [path dists-map]
  (if (< (length path) 2) 0
    (let [[a b & rest] path]
      (+ (nget dists-map a b) (path-dist [b ;rest] dists-map)))))

(def dists-map (build-dists-map (peg/match dists-grammar (slurp "9.txt"))))
(def places (keys dists-map))

(prin "part 1: ")
(pp (min-of (seq [perm :in (permutations places)] (path-dist perm dists-map))))

(prin "part 2: ")
(pp (max-of (seq [perm :in (permutations places)] (path-dist perm dists-map))))
