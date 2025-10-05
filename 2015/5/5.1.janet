(def vowel-grammar
  (peg/compile
    '{:main (set "aeiou")}))

(def double-grammar
  (peg/compile
    '{:main (* (<- :a) (backmatch))}))

(def not-seq-grammar
  (peg/compile
    '{:safe-letter (* (! "ab") (! "cd") (! "pq") (! "xy") :a)
      :main (<- (some :safe-letter))}))

(defn nice [str]
  (let [not-seq (peg/match not-seq-grammar str)]
    (and
      (<= 3 (length (peg/find-all vowel-grammar str)))
      (truthy? (peg/find double-grammar str))
      (and (truthy? not-seq) (= (length (not-seq 0)) (length str))))))


(pp
  (sum
    (seq [line :in (string/split "\n" (slurp "5.txt"))
          :when (not (empty? line))]
      (if (nice line) 1 0))))
