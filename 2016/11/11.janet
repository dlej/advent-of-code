(def raw-floors
  (struct
    ;(peg/match
       ~{:item (/ (group (* "a " (/ (<- :a+) ,keyword)
                            (+ (/ "-compatible microchip" :microchip)
                               (/ " generator" :generator)))) ,|(tuple/brackets ;$))
         :conjunction (* :s* (? ",") :s* (? "and") :s*)
         :items (/ (group (* :item (any (* :conjunction :item)) "." :s*)) ,|(tuple/brackets ;$))
         :floor (* "The " (/ (<- :a+) ,keyword) " floor contains " (+ :items (/ "nothing relevant." [])))
         :main (some :floor)}
       (slurp "input"))))

(def floor-number-map {:first 1 :second 2 :third 3 :fourth 4})

(def floors
  {:elevator 1
   :parts (tuple/brackets
            ;(sorted
               (let [es (tabseq [[_ v] :pairs raw-floors [e _] :in v] e 1)]
                 (seq [e :keys es]
                   (tuple/brackets
                     ;(tuple/join (seq [[f v] :pairs raw-floors
                                        [e_ t] :in v
                                        :when (= e e_)
                                        :when (= t :generator)]
                                    (floor-number-map f))
                                  (seq [[f v] :pairs raw-floors
                                        [e_ t] :in v
                                        :when (= e e_)
                                        :when (= t :microchip)]
                                    (floor-number-map f))))))))})

(defn valid? [fl]
  (prompt :ret
    (loop [i :range [0 (length (fl :parts))]
           :let [[fg fm] ((fl :parts) i)]
           :unless (= fg fm)
           j :range [0 (length (fl :parts))]
           :unless (= i j)
           :let [[ofg _] ((fl :parts) j)]
           :when (= ofg fm)]
      (return :ret false))
    true))

(defn unflatten-parts [flattened]
  (tuple/brackets
    ;(sorted
       (seq [i :in (range 0 (length flattened) 2)]
         (tuple/brackets ;(tuple/slice flattened i (+ i 2)))))))

(defn unique [ind]
  (keys (tabseq [x :in ind] x 1)))

(defn neighbors [fl]
  (unique
    (seq [:let [{:elevator e :parts p} fl
                parts (flatten p)]
          i :range [0 (length parts)]
          j :range [0 (length parts)]
          :when (= e (parts i) (parts j))
          :let [nb-parts (array/slice parts)]
          e- :in [(dec e) (inc e)]
          :when (and (< 0 e-) (< e- 5))
          :before (put nb-parts i e-)
          :before (put nb-parts j e-)
          :let [nb {:elevator e- :parts (unflatten-parts nb-parts)}]
          :when (valid? nb)]
      nb)))

(defn neighbors-with-cost [fl]
  (map |[$ 1] (neighbors fl)))

(defn heuristic-fn [fl]
  (div (sum (map |(- 4 $) (flatten (fl :parts)))) 2))

(defn is-end? [fl]
  (all |(= 4 $) (flatten (fl :parts))))

(use daniel)

(print "part 1: " (dec (length (a-star floors is-end? neighbors-with-cost heuristic-fn))))

(def floors {:elevator 1 :parts (tuple/brackets (tuple/brackets 1 1) (tuple/brackets 1 1) ;(floors :parts))})

(print "part 2: " (dec (length (a-star floors is-end? neighbors-with-cost heuristic-fn))))
