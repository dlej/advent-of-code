(use "./build/day20")

(def [presents]
  (peg/match
    '{:main (number :d+)}
    (slurp "20.txt")))

(def n (div presents 10))
(def arr (divisor n))
(print "part 1: " (min-of (filter |(<= n (arr $)) (range 1 n))))

(def arr (part2 presents))
(print "part 2: " (min-of (filter |(<= presents (arr $)) (range 1 presents))))
