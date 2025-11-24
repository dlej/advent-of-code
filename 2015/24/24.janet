(def packages
  (peg/match
    '{:main (some (* (number :d+) :s*))}
    (slurp "input")))

# (def packages [1 2 3 4 5 7 8 9 10 11])

(var best-length (length packages))
(defn gen-sum-sets [pool s &opt i depth]
  (default i 0)
  (default depth 0)
  (fiber/new
    (fn []
      (loop [j :range [i (length pool)]
             :let [x (pool j)]
             :when (<= x s)]
        (if (= x s)
          (yield [x])
          (loop [sum-set :in (gen-sum-sets pool (- s x) (inc j) (inc depth))
                 :let [this-length (+ depth (length sum-set) 1)]
                 :when (<= this-length best-length)]
            (set best-length this-length)
            (yield (tuple/join [x] sum-set))))))))

(def n (div (sum packages) 3))
(def options (map identity (gen-sum-sets packages n)))
(def least-num (min-of (map length options)))
(def min-size-options (filter |(= least-num (length $)) options))
(print "part 1: " (min-of (map |(* ;$) min-size-options)))

(def n2 (div (sum packages) 4))
(set best-length (length packages))
(def options (map identity (gen-sum-sets packages n2)))
(def least-num (min-of (map length options)))
(def min-size-options (filter |(= least-num (length $)) options))
(print "part 2: " (min-of (map |(* ;$) min-size-options)))
