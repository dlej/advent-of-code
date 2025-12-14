(def [presents trees]
  (peg/match
    ~{:present (/ (* (9 (* (to (set "#.")) (<- 1))) :s*) ,(fn [& cs] (count |(= "#" $) cs)))
      :tree (group (* (number :d+) "x" (number :d+) ": " (6 (* (number :d+) :s*))))
      :main (* (group (some :present)) (group (some :tree)))}
    (slurp "input")))

(use daniel)

(print (count
         (fn [[h w & ns]]
           (let [area (* h w)
                 coverage (sum (seq [[i n] :in (enumerate ns)] (* n (presents i))))]
             (<= coverage area)))
         trees))
# 49x36: 50 58 46 32 38 51

# 0:
# ##.
# .##
# ..#

# 1:
# ###
# ##.
# #..

# 2:
# #.#
# #.#
# ###

# 3:
# ##.
# .##
# ###

# 4:
# #.#
# ###
# #.#

# 5:
# ##.
# ##.
# ###

