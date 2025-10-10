(def wiring-grammar
  (peg/compile
    '{:arr (* " -> ")
      :wire (+ (<- :a+) (number :d+))
      :signal (* (constant "w-signal") :wire :arr :wire)
      :and (* (constant "w-and") :wire " AND " :wire :arr :wire)
      :or (* (constant "w-or") :wire " OR " :wire :arr :wire)
      :lshift (* (constant "w-lshift") :wire " LSHIFT " (number :d+) :arr :wire)
      :rshift (* (constant "w-rshift") :wire " RSHIFT " (number :d+) :arr :wire)
      :not (* (constant "w-not") "NOT " :wire :arr :wire)
      :wiring (group (* (+ :signal :and :or :lshift :rshift :not) :s+))
      :main (some :wiring)}))

(var mem @{})
(defn smart-get [v]
  (if (string? v) (mem v) v))
(defn w-signal [val x] (put mem x (smart-get val)))
(defn w-and [v1 v2 x] (put mem x (band (smart-get v1) (smart-get v2))))
(defn w-or [v1 v2 x] (put mem x (bor (smart-get v1) (smart-get v2))))
(defn w-lshift [v n x] (put mem x (band 0xffff (blshift (smart-get v) n))))
(defn w-rshift [v n x] (put mem x (brshift (smart-get v) n)))
(defn w-not [v x] (put mem x (band 0xffff (bnot (smart-get v)))))

(def funs-by-wire
  (table
    ;(catseq [arr :in (peg/match wiring-grammar (slurp "7.txt"))
              :let [[cmd & args] arr wire (last arr)]]
             [wire [args (compile [(symbol cmd) ;args])]])))

(defn get-value [x]
  (let [[args fun] (funs-by-wire x)]
    (each v args
      (unless (or (= x v) (not (string? v)) (in mem v))
        (get-value v)))
    (fun)
    (smart-get x)))

(def a-val (get-value "a"))
(prin "part 1: ")
(pp a-val)

(put funs-by-wire "b" [[a-val "b"] (compile ['w-signal a-val "b"])])
(set mem @{})
(prin "part 2: ")
(pp (get-value "a"))
