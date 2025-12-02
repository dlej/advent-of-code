(def ranges
  (peg/match
    '{:range (group (* (number :d+) "-" (number :d+) (? ",")))
      :main (some :range)}
    (slurp "input")))

(defn quick-log [n]
  (length (string/format "%d" n)))

(defn get-all-invalid [maxlen &opt max-reps]
  (default max-reps maxlen)
  (def seen @{})
  (seq [i :range [1 (math/pow 10 (div maxlen 2))]
        :let [i-str (string i)]
        reps :range-to [2 (min max-reps (div maxlen (length i-str)))]
        :let [i-rep (scan-number (string/repeat i-str reps))]
        :unless (in seen i-rep)]
    (put seen i-rep 1)
    i-rep))

(defn in-ranges? [n]
  (prompt :result
    (loop [[a b] :in ranges]
      (if (and (<= a n) (<= n b))
        (return :result true)))
    false))

(def maxlen (quick-log (max-of (flatten ranges))))

(prin "part 1: ")
(pp (sum (filter in-ranges? (get-all-invalid maxlen 2))))

(prin "part 2: ")
(pp (sum (filter in-ranges? (get-all-invalid maxlen))))
