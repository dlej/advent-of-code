(def box-grammar (peg/compile
                   '{:side (number (some :d))
                     :main (* :side "x" :side "x" :side)}))

(defn box-ribbon [box]
  (let [[l w h] box
        faces [(+ l w) (+ w h) (+ h l)]]
    (+ (* 2 (min ;faces)) (* ;box))))

(pp (sum
      (seq [line :in (string/split "\n" (slurp "2.txt"))
            :let [box (peg/match box-grammar line)]
            :when box]
        (box-ribbon box))))
