(def input-grammar
  (peg/compile
    ~{:instr (group (* (/ (<- (set "LR")) ,keyword) (number :d+)))
      :main (some (* :instr (any (if-not :instr 1))))}))

(defn add [u v]
  (tuple ;(seq [i :range [0 (length u)]] (+ (u i) (v i)))))

(defn mul [u a]
  (tuple ;(seq [x :in u] (* x a))))

(defn get-final-delta [instructions &opt heading i]
  (default heading [0 1])
  (default i 0)
  (if (>= i (length instructions))
    [0 0]
    (let [[lr dist] (instructions i)
          heading (case lr
                    :L [(- (heading 1)) (heading 0)]
                    :R [(heading 1) (- (heading 0))])
          delta (mul heading dist)]
      (add delta (get-final-delta instructions heading (inc i))))))

(prin "part 1: ")
(loop [input :in (string/split "\n" (slurp "input"))
       :unless (empty? input)
       :let [instructions (peg/match input-grammar input)]]
  (pp (sum (map math/abs (get-final-delta instructions)))))

(defn find-first-repeat [instructions]
  (def grid @{[0 0] 1})
  (var heading [0 1])
  (var pos [0 0])
  (prompt :br
    (loop [[lr dist] :in instructions]
      (set heading (case lr
                     :L [(- (heading 1)) (heading 0)]
                     :R [(heading 1) (- (heading 0))]))
      (for i 0 dist
        (set pos (add pos heading))
        (put grid pos (inc (get grid pos 0)))
        (if (< 1 (grid pos)) (return :br pos))))))

(prin "part 2: ")
(loop [input :in (string/split "\n" (slurp "input"))
       :unless (empty? input)
       :let [instructions (peg/match input-grammar input)]]
  (pp (sum (map math/abs (find-first-repeat instructions)))))
