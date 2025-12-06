(use spork)

(def homework
  (math/trans
    (peg/match
      ~{:item (+ (number :d+) (/ (<- (set "+*")) ,symbol))
        :nbsp (if-not "\n" :s)
        :line (group (* (some (* :item (any :nbsp))) "\n"))
        :main (some :line)}
      (slurp "input"))))

(defn do-homework [hw]
  (sum (map |((compile [(last $) ;(array/slice $ 0 (dec (length $)))])) hw)))


(print "part 1: " (do-homework homework))

(def raw-homework
  (string/join
    (map string/join
         (math/trans
           (math/fliplr
             (peg/match
               '{:chr (if-not "\n" 1)
                 :line (group (* (some (<- :chr)) "\n"))
                 :main (some :line)}
               (slurp "input")))))
    "\n"))

(def homework
  (peg/match
    ~{:block (group (* :s* (some (* (number :d+) :s*)) (/ (<- (set "+*")) ,symbol)))
      :main (some :block)}
    raw-homework))

(print "part 2: " (do-homework homework))
