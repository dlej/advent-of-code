(def decompression-grammar
  (peg/compile
    '{:decompression (* (only-tags (* "(" (number :d+ 10 :chars) "x" (number :d+ 10 :repeat) ")"
                                      (<- (lenprefix (backref :chars) 1) :str)))
                        (lenprefix (backref :repeat) (backref :str)))
      :main (% (some (+ :decompression (<- :S))))}))

(prin "part 1: ")
(print (length (first (peg/match decompression-grammar (slurp "input")))))

(defn decompress-v2 [str]
  ((dyn :decompress-v2) str))
(def decompression-v2-grammar
  (peg/compile
    ~{:decompression (group (* (only-tags (* "(" (number :d+ 10 :chars) "x" (number :d+ 10 :repeat) ")"
                                             (<- (lenprefix (backref :chars) 1) :str)))
                               (backref :repeat) (/ (backref :str) ,decompress-v2)))
      :not-decompression (<- (any (if-not :decompression :S)))
      :main (some (+ :decompression :not-decompression))}))
(setdyn :decompress-v2 (fn [str]
                         (peg/match decompression-v2-grammar str)))

(defn tree-length [tree]
  (sum (walk (fn [elem]
               (if (array? elem)
                 (let [[n t] elem]
                   (* n (tree-length t)))
                 (length elem))) tree)))

(prin "part 2: ")
(print (tree-length (decompress-v2 (slurp "input"))))
