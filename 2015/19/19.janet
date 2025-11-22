(import set)

(def [replacements molecule]
  (peg/match
    '{:replacement (group (* (<- :w+) :s+ "=>" :s+ (<- :w+)))
      :main (* (group (some (* :replacement :s*))) (<- :w+))}
    (slurp "19.txt")))

(def s (set/new))
(loop [[p r] :in replacements
       i :in (string/find-all p molecule)]
  (set/add s (string (peg/replace {:main p} r molecule i))))

(print "part 1: " (length s))

(use daniel) # import a-star search
# go backwards! avoid the explosion
(defn neighbor-fn [mol]
  (seq [[r p] :in replacements
        i :in (string/find-all p mol)]
    [(string (peg/replace {:main p} r mol i)) 1]))

(print "part 2: " (dec (length (a-star molecule "e" neighbor-fn |(length $)))))
