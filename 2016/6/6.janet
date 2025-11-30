(use spork)

(def messages
  (peg/match
    '{:main (some (group (* (some (<- :a)) :s+)))}
    (slurp "input")))

(defn count-items [ind]
  (let [t @{}]
    (loop [x :in ind]
      (put t x (inc (get t x 0))))
    t))

(defn most-common [ind]
  ((last (sorted (pairs (count-items ind))
                 (fn [[a b] [c d]] (< b d))))
    0))

(print "part 1: " (string/join (map most-common (math/trans messages))))

(defn least-common [ind]
  ((first (sorted (pairs (count-items ind))
                  (fn [[a b] [c d]] (< b d))))
    0))

(print "part 2: " (string/join (map least-common (math/trans messages))))
