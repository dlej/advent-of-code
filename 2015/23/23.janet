(def ops {"+" + "-" -})

(def program
  (peg/match
    ~{:register (+ (/ "a" :a) (/ "b" :b))
      :offset (* (/ (<- (set "+-")) ,ops) (number :d+))
      :instr (/ (<- :w+) ,keyword)
      :instruction (group (* :instr :s+ (+ (* :register "," :s* :offset)
                                           :register
                                           :offset)
                             :s*))
      :main (some :instruction)}
    (slurp "input")))

(defn run [program &opt a b pc]
  (default a 0)
  (default b 0)
  (default pc 0)
  (def reg @{:a a :b b})
  (var pc pc)
  (while (and (<= 0 pc) (< pc (length program)))
    (def [instr & args] (program pc))
    (set pc (case instr
              :hlf (do
                     (put reg (args 0) (div (reg (args 0)) 2))
                     (inc pc))
              :tpl (do
                     (put reg (args 0) (* (reg (args 0)) 3))
                     (inc pc))
              :inc (do
                     (put reg (args 0) (inc (reg (args 0))))
                     (inc pc))
              :jmp ((args 0) pc (args 1))
              :jie (if (even? (reg (args 0)))
                     ((args 1) pc (args 2))
                     (inc pc))
              :jio (if (= 1 (reg (args 0)))
                     ((args 1) pc (args 2))
                     (inc pc)))))
  reg)

(print "part 1: " ((run program) :b))
(print "part 1: " ((run program 1) :b))
