(def rotations
  (peg/match
    ~{:line (group
              (* (+ (/ "L" -)
                    (/ "R" +)) (number :d+) :s*))
      :main (some :line)}
    (slurp "input")))

(var n 50)
(var c 0)
(loop [[op m] :in rotations]
  (set n (mod (eval [op n m]) 100))
  (when (= n 0)
    (++ c)))

(print "part 1: " c)

(defn count-clicks [n k]
  (if (< n k)
    (count |(= (mod $ 100) 0) (range (inc n) (inc k)))
    (count |(= (mod $ 100) 0) (range k n))))

(var n 50)
(var c 0)
(loop [[op m] :in rotations
       :let [k (eval [op n m])
             d (count-clicks n k)]]
  (+= c d)
  (set n (mod k 100)))

(print "part 2: " c)
