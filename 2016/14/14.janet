(use daniel)

(def salt (slurp "input"))

(defn repeat-grammar [n]
  (peg/compile
    ~{:rep (* (<- :h :digit) (,(dec n) (backmatch :digit)))
      :main (* (any (if-not :rep 1)) :rep)}))

(def repeat-3-grammar (repeat-grammar 3))
(def repeat-5-grammar (repeat-grammar 5))

(def upto 30000)
(def hashes (seq [i :range [0 upto]]
              (md5 (string/format "%s%d" salt i))))

(defn find-nth-key [n hashes]
  (def repeat-5s (tabseq [i :range [0 16]] (string/format "%x" i) @[]))
  (loop [i :range [0 upto]
         :let [h (hashes i)
               m (peg/match repeat-5-grammar h)]
         :unless (nil? m)
         :let [[d] m]]
    (array/push (repeat-5s d) i))

  (def keys @[])
  (prompt :loop
    (loop [i :range [0 upto]
           :let [h (hashes i)
                 m (peg/match repeat-3-grammar h)]
           :unless (nil? m)
           :let [[d] m]
           j :in (repeat-5s d)
           :when (and (< i j) (<= j (+ i 1000)))]
      (array/push keys i)
      (if (= n (length keys))
        (return :loop i)))))

(print "part 1: " (find-nth-key 64 hashes))

(def stretched-hashes
  (seq [i :range [0 upto]]
    (var h (string/format "%s%d" salt i))
    (loop [:repeat 2017]
      (set h (md5 h)))
    (if (= 0 (% i 1000))
      (prin ".") (flush))
    h))

(print)
(print "part 2: " (find-nth-key 64 stretched-hashes))
