(import spork/json)

(var calc-sum nil)

(defn calc-sum-table [ds]
  (let [vals (values ds)]
    (if (any? (map |(= $ "red") vals))
      0
      (sum (map |(calc-sum $) vals)))))

(set calc-sum
     (fn [ds]
       (cond
         (table? ds) (calc-sum-table ds)
         (array? ds) (sum (map calc-sum ds))
         (number? ds) ds
         0)))

(pp (calc-sum (json/decode (slurp "12.txt"))))
