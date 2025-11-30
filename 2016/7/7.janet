(def ipv7-grammar
  (peg/compile
    '{:abba (% (* (<- :a :first-a)
                  (<- (if-not (backmatch :first-a) :a) :first-b)
                  (<- (backmatch :first-b))
                  (<- (backmatch :first-a))))
      :no-abba (some (if-not :abba :a))
      :collect-abba (group (some (+ :abba :a)))
      :main (* :collect-abba (any (* "[" :no-abba "]" (? :collect-abba))) -1)}))

(defn supports-tls? [ip]
  (let [m (peg/match ipv7-grammar ip)]
    (and (not (nil? m))
         (< 0 (length (array/concat ;m))))))

(print "part 1: "
       (count supports-tls?
              (seq [line :in (string/split "\n" (slurp "input")) :unless (empty? line)]
                line)))

(def aba-grammar
  (peg/compile
    '{:main (% (* (<- :a :first-a)
                  (<- (if-not (backmatch :first-a) :a))
                  (<- (backmatch :first-a))))}))

(defn aba-supernet-grammar [a b]
  (peg/compile
    ~{:aba (* ,a ,b ,a)
      :main (+ (* (> 0 (* (any (if-not :aba :a)) :aba)) (some (+ (<- :aba) :a)))
               (some (+ (* "]" (some (+ (<- :aba) :a))) 1)))}))

(defn bab-grammar [a b]
  (peg/compile
    ~{:main (some (+ (* "[" (any (+ (<- (* ,b ,a ,b)) :a)) "]") 1))}))

(defn supports-ssl? [ip]
  (prompt :ret
    (loop [i :in (peg/find-all aba-grammar ip)
           :let [a (string/slice ip i (inc i))
                 b (string/slice ip (inc i) (+ i 2))
                 m-aba (peg/match (aba-supernet-grammar a b) ip)
                 m-bab (peg/match (bab-grammar a b) ip)]]
      (if (and (not (nil? m-aba))
               (< 0 (length m-aba))
               (not (nil? m-bab))
               (< 0 (length m-bab)))
        (return :ret true)))
    false))

(print "part 2: "
       (count supports-ssl?
              (seq [line :in (string/split "\n" (slurp "input")) :unless (empty? line)]
                line)))
