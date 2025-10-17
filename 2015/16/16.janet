(def tape
  (table
    ;(peg/match
       '{:main (some (* (<- :w+) ":" :s+ (number :d+) :s+))}
       (slurp "16.tape"))))

(def aunts
  (table
    ;(peg/match
       ~{:pair (* (<- :w+) ": " (number :d+))
         :pairs (/ (* :pair (any (* "," :s* :pair))) ,table)
         :main (some (* "Sue " (number :d+) ": " :pairs :s+))}
       (slurp "16.txt"))))

(defn matches [things]
  (all truthy? (seq [[k v] :pairs things]
                 (and (in tape k)) (= v (tape k)))))

(prin "part 1: ")
(loop [[aunt things] :pairs aunts
       :when (matches things)]
  (pp aunt))

(defn matches-2 [things]
  (all
    truthy?
    (seq [[k v] :pairs things]
      (match k
        "cats" (> v (tape k))
        "trees" (> v (tape k))
        "pomeranians" (< v (tape k))
        "goldfish" (< v (tape k))
        (and (in tape k)
             (= v (tape k)))))))

(prin "part 2: ")
(loop [[aunt things] :pairs aunts
       :when (matches-2 things)]
  (pp aunt))
