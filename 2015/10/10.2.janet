(def elements-grammar
  (peg/compile
    '{:decay (group (* (<- :w+) (any (* "." (<- :w+)))))
      :line (group (* (<- :w+) :s+ (<- :d+) :s+ :decay :s+))
      :main (some :line)}))

(def digits-by-name @{})
(def name-by-digits @{})
(def decay-by-name @{})
(loop [[name digits decay] :in (peg/match elements-grammar (slurp "elements.tsv"))]
  (put digits-by-name name digits)
  (put name-by-digits digits name)
  (put decay-by-name name decay))

(def input-grammar
  (peg/compile
    '{:main (* (<- :d+) :s (number :d+))}))

(def [digits n] (peg/match input-grammar (slurp "10.txt")))
(var atom-counts @{(name-by-digits digits) 1})

(defn count-length [atom-counts]
  (sum (seq [[name m] :pairs atom-counts] (* (length (digits-by-name name)) m))))

(for i 0 50
  (let [new-atom-counts (table ;(catseq [k :keys digits-by-name] [k 0]))]
    (loop [[name m] :pairs atom-counts
           :when (< 0 m)
           new-name :in (decay-by-name name)]
      (put new-atom-counts new-name (+ (new-atom-counts new-name) m)))
    (set atom-counts new-atom-counts)))

(pp (count-length atom-counts))
