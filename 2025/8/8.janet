(def jboxes
  (peg/match
    '{:line (group (* (number :d+) "," (number :d+) "," (number :d+) :s*))
      :main (some :line)}
    (slurp "input")))

(defn dist2 [u v]
  (sum (map |(let [d (- (u $) (v $))] (* d d)) (range (length u)))))

(def dist2s
  (sorted
    (seq [i :range [0 (length jboxes)]
          j :range [(inc i) (length jboxes)]]
      [(dist2 (jboxes i) (jboxes j)) i j])))

(use daniel)

(def circuits (tabseq [[i _] :in (enumerate jboxes)] i @{i 1}))
(def unique-circuits (table/clone circuits))
(loop [[n [d i j]] :in (enumerate dist2s)
       :let [ci (circuits i)
             cj (circuits j)]
       :unless (has-key? ci j)]
  (loop [k :keys cj]
    (put ci k 1)
    (put circuits k ci)
    (put unique-circuits k nil))
  (when (= (dec 1000) n)
    (print "part 1: " (reduce * 1 (take 3 (sorted (map length (values unique-circuits)) >)))))
  (when (= 1 (length unique-circuits))
    (print "part 2: " (* ((jboxes i) 0) ((jboxes j) 0)))
    (os/exit 0)))

(pp unique-circuits)
