(defn gget [grid i j]
  (-> grid i j))

(defn gput [grid i j x]
  (put (grid i) j x))

(defn rect [grid a b &opt x]
  (default x true)
  (for i 0 b
    (for j 0 a
      (gput grid i j x))))

(defn cget [grid j]
  (seq [row :in grid] (row j)))

(defn cput [grid j col]
  (loop [i :range [0 (length grid)]]
    (gput grid i j (col i))))

(defn rotate [v n]
  (let [l (length v)
        n (% n l)
        m (- l n)
        h (array/slice v 0 m)
        t (array/slice v m l)]
    (array/concat t h)))

(defn rotate-row [grid i n]
  (put grid i (rotate (grid i) n)))

(defn rotate-col [grid j n]
  (cput grid j (rotate (cget grid j) n)))


(def [H W] [6 50])
(def screen
  (seq [_ :range [0 H]]
    (seq [_ :range [0 W]] false)))

(defn display [scrn]
  (loop [row :in scrn]
    (loop [x :in row]
      (prin (if x "#" ".")))
    (print)))

(def instructions
  (peg/match
    '{:rect (* (/ "rect" rect) :s+ (number :d+) "x" (number :d+))
      :rotate (* (+ (/ "rotate row y=" rotate-row)
                    (/ "rotate column x=" rotate-col))
                 (number :d+) " by " (number :d+))
      :line (group (* (+ :rect :rotate) :s*))
      :main (some :line)}
    (slurp "input")))

(loop [[f & args] :in instructions]
  (eval [f 'screen ;args]))

(print "part 1: " (sum (map |(count identity $) screen)))
(print "part 2:")
(display screen)
