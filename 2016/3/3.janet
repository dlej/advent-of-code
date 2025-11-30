(def triangles-grammar
  (peg/compile
    ~{:line (group (* :s* (number :d+) :s* (number :d+) :s* (number :d+) :s*))
      :main (some :line)}))

(defn possible? [t]
  (let [[a b c] (sorted t)]
    (< c (+ a b))))

(def triangles (peg/match triangles-grammar (slurp "input")))
(prin "part 1: ")
(pp (sum (seq [t :in triangles] (if (possible? t) 1 0))))

(def transp-doc
  (string/join
    (seq [i :range [0 3]
          row :in triangles]
      (string (row i))) " "))
(def transp-triangles (peg/match triangles-grammar transp-doc))
(prin "part 2: ")
(pp (sum (seq [t :in transp-triangles] (if (possible? t) 1 0))))
