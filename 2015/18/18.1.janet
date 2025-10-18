(def initial-board
  (peg/match
    '{:light (+ (/ "#" :on) (/ "." :off))
      :main (some (group (* (some :light) :s*)))}
    (slurp "18.txt")))

(defn pp-board [board]
  (loop [line :in board]
    (loop [light :in line]
      (prin (case light :on "#" :off ".")))
    (print)))

(defn gget [grid i j]
  (cond
    (< i 0) :off
    (>= i (length grid)) :off
    (< j 0) :off
    (>= j (length (grid 0))) :off
    ((grid i) j)))

(defn neighbors [i j]
  (fiber/new (fn []
               (loop [a :range-to [-1 1]
                      b :range-to [-1 1]
                      :unless (and (= a 0) (= b 0))]
                 (yield [(+ i a) (+ j b)])))))

(defn conway [board]
  (seq [i :range [0 (length board)]
        :let [line (board i)]]
    (seq [j :range [0 (length line)]
          :let [light (line j)
                on-neighbors (count |(= (gget board ;$) :on) (neighbors i j))]]
      (case light
        :on (case on-neighbors
              2 :on
              3 :on
              :off)
        :off (case on-neighbors
               3 :on
               :off)))))

(var board initial-board)
(for i 0 100
  (set board (conway board)))

(pp (count |(= $ :on) (flatten board)))
