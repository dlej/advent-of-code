(def diagram
  (peg/match
    '{:sym (set "S^")
      :cap (* (> :sym) (column) :sym)
      :line (group (* (some (+ :cap :S)) "\n"))
      :main (some :line)}
    (slurp "input")))

(def [[init] & splitter-lines] diagram)
(def beams @{init 1})
(var split-count 0)
(loop [line :in splitter-lines
       i :in line
       :when (has-key? beams i)
       :before (do
                 (++ split-count)
                 (put beams i nil))
       j :in [(dec i) (inc i)]]
  (put beams j 1))

(print "part 1: " split-count)

(def timelines @{init 1})
(loop [line :in splitter-lines
       i :in line
       :when (has-key? timelines i)
       :let [t (timelines i)]
       :before (put timelines i nil)
       j :in [(dec i) (inc i)]]
  (put timelines j (+ t (get timelines j 0))))

(print "part 2: " (sum (values timelines)))
