(def program
  (peg/match
    ~{:nbsp (if-not "\n" :s)
      :instr (group (*
                      (+ (/ "cpy" cpy-fn)
                         (/ "inc" inc-fn)
                         (/ "dec" dec-fn)
                         (/ "jnz" jnz-fn))
                      :s*
                      (some (* (+ (number (* (? "-") :d+))
                                  (/ (<- :a+) ,keyword))
                               (any :nbsp)))
                      :s*))
      :main (some :instr)}
    (slurp "input")))

(defn optimize [prog]
  (let [new-prog @{}]
    (var pc-map @{})
    (var i 0)
    (var j 0)
    (while (< i (length prog))
      (let [lookahead (array/slice prog i (min (+ i 3) (length prog)))]
        (put pc-map i j)
        (put new-prog j
             (match lookahead
               [['inc-fn a]
                ['dec-fn b]
                ['jnz-fn b -2]]
               (do
                 (+= i 3)
                 @['add-fn b a])
               [['jnz-fn a b]]
               (do
                 (++ i)
                 ['jnz-fn a (+ i b -1)])
               (do
                 (++ i)
                 (array/slice (lookahead 0))))))
      (++ j))
    (seq [i :range [0 (length new-prog)]
          :let [instr (new-prog i)]]
      (match instr
        ['jnz-fn a b]
        @['jnz-fn a (- (pc-map b) i)]
        instr))))

(def program (optimize program))

(defn val [state v]
  (if (keyword? v)
    (state v)
    v))

(defn inc-pc [state]
  (put state :pc (inc (state :pc))))

(defn cpy-fn [state v r]
  (put state r (val state v))
  (inc-pc state))

(defn inc-fn [state r]
  (put state r (inc (state r)))
  (inc-pc state))

(defn dec-fn [state r]
  (put state r (dec (state r)))
  (inc-pc state))

(defn jnz-fn [state v d]
  (put state :pc
       (if (not= 0 (val state v))
         (+ (state :pc) d)
         (inc (state :pc)))))

(defn add-fn [state v r]
  (put state r (+ (val state v) (state r)))
  (inc-pc state))

(def program (optimize program))
(def state @{:pc 0 :a 0 :b 0 :c 0 :d 0})
(var instr nil)
(while (set instr (get program (state :pc)))
  (let [[cmd & args] instr]
    (eval [cmd 'state ;args])))

(print "part 1: " (state :a))

(def state @{:pc 0 :a 0 :b 0 :c 1 :d 0})
(var instr nil)
(while (set instr (get program (state :pc)))
  (let [[cmd & args] instr]
    (eval [cmd 'state ;args])))

(print "part 2: " (state :a))
