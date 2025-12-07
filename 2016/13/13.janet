(def favorite-number
  (scan-number (slurp "input")))

(def n-bits (tabseq [i :range [0 16]]
              (first (string/format "%x" i))
              (count |(< 0 (band i (blshift 1 $))) (range 4))))

(use daniel)
(defn-memoize wall? [x y]
  (let [s (+ favorite-number
             (* x x)
             (* 3 x)
             (* 2 x y)
             y
             (* y y))
        hex (string/format "%x" s)]
    (odd? (sum (map n-bits hex)))))

(defn neighbors [x y]
  (filter |(and (not (apply wall? $))
                (<= 0 ($ 0))
                (<= 0 ($ 1))) [[(dec x) y]
                               [(inc x) y]
                               [x (dec y)]
                               [x (inc y)]]))

(defn neighbor-fn [[x y]]
  (map |[$ 1] (neighbors x y)))

(def [tx ty] [31 39])
(def is-end? |(= $ [tx ty]))
(defn heuristic-fn [[x y]]
  (+ (math/abs (- x tx))
     (math/abs (- y ty))))

(print "part 1: " (dec (length (a-star [1 1] is-end? neighbor-fn heuristic-fn))))

(def seen @{[1 1] 1})
(var frontier @[[1 1]])
(loop [i :range [0 50]
       :let [new-frontier @[]]
       :after (set frontier new-frontier)
       [x y] :in frontier
       [a b] :in (neighbors x y)
       :unless (has-key? seen [a b])]
  (array/push new-frontier [a b])
  (put seen [a b] 1))

(print "part 2: " (length seen))
