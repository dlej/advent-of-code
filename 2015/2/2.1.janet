(def box-grammar (peg/compile
                   '{:side (number (some :d))
                     :main (* :side "x" :side "x" :side)}))

(defn box-paper [box]
  (let [[l w h] box
        sides [(* l w) (* w h) (* h l)]]
    (+ (min ;sides) (* 2 (+ ;sides)))))

(pp (sum
      (seq [line :in (string/split "\n" (slurp "2.txt"))
            :let [box (peg/match box-grammar line)]
            :when box]
        (box-paper box))))
