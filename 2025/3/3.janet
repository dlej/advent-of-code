(defn total-joltage-grammar [&opt n]
  (default n 2)
  (peg/compile
    ~{:init (only-tags (constant ,(dec n) :i))
      :i (backref :i)
      :dec (only-tags (/ (backref :i) ,dec :i))
      :max (/ (group (some (<- :d))) ,max-of :max-res)
      :loop (* :init
               (repeat ,n
                 (* (look (sub (to (* (lenprefix :i :d) "\n")) :max))
                    (thru (backmatch :max-res))
                    :dec)))
      :line (/ (% (* :loop (thru "\n"))) ,scan-number)
      :main (/ (group (some :line)) ,sum)}))

(def input (slurp "input"))
(print "part 1: "
       (first (peg/match (total-joltage-grammar 2) input)))
(print "part 2: "
       (first (peg/match (total-joltage-grammar 12) input)))
