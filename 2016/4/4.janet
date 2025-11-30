(def rooms
  (peg/match
    '{:name (group (some (* (<- :a+) "-")))
      :line (group (* :name (number :d+) "[" (<- :a+) "]" :s*))
      :main (some :line)}
    (slurp "input")))

(defn count-items [ind]
  (let [t @{}]
    (loop [x :in ind]
      (put t x (inc (get t x 0))))
    t))

(defn checksum [name]
  (string/join
    (let [s (string/join name)
          counts (count-items s)
          sorted-pairs (sorted (pairs counts) (fn [[a b] [c d]] (< [(- b) a] [(- d) c])))]
      (map |(string/format "%c" ($ 0)) (take 5 sorted-pairs)))))

(prin "part 1: ")
(pp (sum (map |($ 1) (filter |(= (checksum ($ 0)) ($ 2)) rooms))))

(def chr-a (chr "a"))
(defn decipher-one [x n]
  (+ chr-a (% (+ (- x chr-a) n) 26)))

(prin "part 2: ")
(loop [[name id _] :in rooms]
  (loop [word :in name]
    (if (= "northpole"
           (string/join (seq [c :in word]
                          (string/format "%c" (decipher-one c id)))))
      (print id))))
