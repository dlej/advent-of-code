(def instructions
  (peg/match
    ~{:value (* (constant value-fn) "value " (number :d+) " goes to bot " (number :d+))
      :bot (* (constant bot-fn) "bot " (number :d+) " gives low to " (/ (<- :a+) ,keyword) :s* (number :d+) " and high to " (/ (<- :a+) ,keyword) :s* (number :d+))
      :line (/ (group (* (+ :value :bot) :s*)) ,|(tuple ;$))
      :main (some :line)}
    (slurp "input")))

(def bot-chans
  (from-pairs
    (seq [[t n & _] :in instructions :when (= t 'bot-fn)]
      [n (ev/chan)])))
(def output-chan (ev/chan))
(def bot-responsibilities @{})

(defn send [to n v]
  (case to
    :bot (ev/give (bot-chans n) v)
    :output (ev/give output-chan [n v])))

(defn value-fn [v n]
  (ev/give (bot-chans n) v))

(defn bot-fn [n lo-to lo-n hi-to hi-n]
  (loop [:let [v1 (ev/take (bot-chans n))
               v2 (ev/take (bot-chans n))
               [lo hi] (sorted [v1 v2])]
         :before (put bot-responsibilities n [lo hi])
         [to m v] :in [[lo-to lo-n lo] [hi-to hi-n hi]]]
    (send to m v)))

(defn output-fn []
  (from-pairs
    (seq [[f & args] :in instructions
          :when (= f 'bot-fn)
          :let [[_ lo-to lo-n hi-to hi-n] args]
          [to n] :in [[lo-to lo-n] [hi-to hi-n]]
          :when (= to :output)]
      (ev/take output-chan))))

(loop [instr :in instructions]
  (ev/call (compile instr)))
(def output (resume (fiber/new output-fn)))

(print "part 1: "
       (first (seq [[n vs] :pairs bot-responsibilities :when (= vs [17 61])] n)))

(print "part 2: " (* (output 0) (output 1) (output 2)))
