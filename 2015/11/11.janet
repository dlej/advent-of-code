(def straights
  (seq [i :range [0 24]
        :let [a (chr "a") b (chr "b") c (chr "c")]]
    (string/from-bytes (+ a i) (+ b i) (+ c i))))

(def three-straight-grammar
  (peg/compile
    ~{:main (<- (+ ,;straights))}))

(defn has-straight? [str] (not (nil? (peg/find three-straight-grammar str))))

(def iol-grammar
  (peg/compile '{:main (<- (+ "i" "o" "l"))}))

(defn has-iol? [str] (not (nil? (peg/find iol-grammar str))))

(def different-pairs-grammar
  (peg/compile
    '{:first-pair (accumulate (* (<- :a :chr) (<- (backmatch :chr))))
      :not-chr (if-not (backmatch :chr) :a)
      :second-pair (accumulate (* (<- :not-chr :chr2) (<- (backmatch :chr2))))
      :main (* :first-pair (thru :second-pair))}))

(defn has-different-pairs? [str] (not (nil? (peg/find different-pairs-grammar str))))

(defn is-valid? [str] (and (has-straight? str) (not (has-iol? str)) (has-different-pairs? str)))

(def a-ascii (chr "a"))
(def z-ascii (chr "z"))
(defn next-bytes [bytes &opt i]
  (default i (- (length bytes) 1))
  (let [x (bytes i)]
    (if (= x z-ascii)
      (next-bytes (array/concat (array/slice bytes 0 i) [a-ascii] (array/slice bytes (inc i))) (dec i))
      (array/concat (array/slice bytes 0 i) [(inc x)] (array/slice bytes (inc i))))))

(defn next-string [str] (string/from-bytes ;(next-bytes (string/bytes str))))

(defn next-password [str]
  (var str (next-string str))
  (while (not (is-valid? str)) (set str (next-string str)))
  str)

(loop [password :in (string/split "\n" (slurp "11.txt"))
       :when (not (empty? password))
       :let [password-2 (next-password password)]]
  (prin "part 1: ")
  (print password-2)
  (prin "part 2: ")
  (print (next-password password-2)))
