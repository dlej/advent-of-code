(def [my-row my-col]
  (peg/match
    '{:main (* :D+ (number :d+) :D+ (number :d+))}
    (slurp "input")))

(defn th-code [r c]
  (let [n (+ (dec r) c)]
    (+ c (div (* n (dec n)) 2))))

(def first-code 20151125)
(def a 252533)
(def m 33554393)

(defn base2 [n]
  (if (< n 2)
    [n]
    (tuple/join [(mod n 2)] (base2 (div n 2)))))

(defn nth-code [n]
  (var factor 1)
  (var base-factor a)
  (loop [:let [n_ (dec n)
               b2 (base2 n_)]
         b :in b2]
    (if (= b 1)
      (set factor (mod (* factor base-factor) m)))
    (set base-factor (mod (* base-factor base-factor) m))
    ())
  (mod (* first-code factor) m))

(print (nth-code (th-code my-row my-col)))
