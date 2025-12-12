(def device-outputs
  (from-pairs
    (peg/match
      ~{:name (/ (<- :a+) ,keyword)
        :line (group (* :name ": " (group (sub (thru "\n") (split " " :name)))))
        :main (some :line)}
      (slurp "input"))))

(def device-inputs @{})
(loop [[device outputs] :pairs device-outputs
       x :in outputs]
  (unless (has-key? device-inputs x) (put device-inputs x @[]))
  (array/push (device-inputs x) device))
(def device-inputs (freeze device-inputs))

(use daniel)
(defn-memoize paths-from-to [dag-as-inputs a b exclude]
  (let [inputs (dag-as-inputs b)]
    (if (nil? inputs)
      0
      (sum (seq [input :in inputs
                 :unless (index-of input exclude)]
             (if (= a input) 1 (paths-from-to dag-as-inputs a input exclude)))))))

(print "part 1: " (paths-from-to device-inputs :you :out []))

(print "part 2: "
       (+ (* (paths-from-to device-inputs :svr :fft [:dac])
             (paths-from-to device-inputs :fft :dac [])
             (paths-from-to device-inputs :dac :out [:fft]))
          (* (paths-from-to device-inputs :svr :dac [:fft])
             (paths-from-to device-inputs :dac :fft [])
             (paths-from-to device-inputs :fft :out [:dac]))))
