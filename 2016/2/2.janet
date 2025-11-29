(def instructions
  (peg/match
    ~{:line (group (* (some (/ (<- :a) ,keyword)) :s*))
      :main (some :line)}
    (slurp "input")))


(defn get-key [grid [x y]]
  (let [row (get grid (- (length grid) 1 y))]
    (if (nil? row)
      nil
      (get row x))))

(defn step [grid [x y] dir]
  (let [next-pos
        (case dir
          :U [x (inc y)]
          :R [(inc x) y]
          :D [x (dec y)]
          :L [(dec x) y])]
    (if (nil? (get-key grid next-pos))
      [x y]
      next-pos)))

(def keypad
  [[1 2 3]
   [4 5 6]
   [7 8 9]])

(defn press-buttons [grid instructions]
  (var pos [1 1])
  (seq [line :in instructions]
    (loop [dir :in line]
      (set pos (step grid pos dir)))
    (get-key grid pos)))

(prin "part 1: ")
(loop [b :in (press-buttons keypad instructions)] (prin b))
(print)

(def real-keypad
  [[nil nil 1 nil nil]
   [nil 2 3 4 nil]
   [5 6 7 8 9]
   [nil "A" "B" "C" nil]
   [nil nil "D" nil nil]])

(prin "part 2: ")
(loop [b :in (press-buttons real-keypad instructions)] (prin b))
(print)
