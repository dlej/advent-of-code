(use daniel)
(use sh)

(def manual
  (peg/match
    '{:lights (group (* "[" (some (+ (/ "." 0) (/ "#" 1))) "]"))
      :numbers (split "," (number :d+))
      :buttons (group (* "(" (sub (to ")") :numbers) ")"))
      :schematic (group (* (some (* :buttons :s*))))
      :joltages (group (* "{" (sub (to "}") :numbers) "}"))
      :line (group (* :lights :s* :schematic :s* :joltages :s*))
      :main (some :line)}
    (slurp "input")))

(defn linear-form [buttons m]
  (seq [i :range [0 m]]
    (filter |(index-of i (buttons $)) (range (length buttons)))))

(defn format-with-sep [xs fmt sep]
  (string/join (seq [x :in xs] (string/format fmt x)) sep))

(def solution-grammar
  (peg/compile
    '{:objective (* "objective value:" :s* (number :d+) :s*)
      :value (group (* "x" (number :d+) :s* (number :d+) (thru "\n")))
      :main (* (to :objective) :objective (some :value))}))

(defn solve-lights [lights buttons]
  (def m (length lights))
  (def n (length buttons))
  (def f (file/open "10.tmp.lp" :w))
  (file/write f "MINIMIZE\n")
  (file/write f (format-with-sep (range n) "x%d" " + "))
  (file/write f "\nSUBJECT TO\n")
  (loop [[i constraint] :in (enumerate (linear-form buttons m))]
    (file/write f (string/format "c%d: " i))
    (file/write f (format-with-sep constraint "x%d" " + "))
    (file/write f (string/format " - 2 s%d = %d\n" i (lights i))))
  (file/write f "BOUNDS\n")
  (file/write f (format-with-sep (range m) "s%d >= 0" "\n"))
  (file/write f "\nBINARIES\n")
  (file/write f (format-with-sep (range n) "x%d" " "))
  (file/write f "\nGENERALS\n")
  (file/write f (format-with-sep (range m) "s%d" " "))
  (file/write f "\nEND\n")
  (file/close f)

  ($< scip < `read 10.tmp.lp
optimize
display solution
write solution 10.tmp.sol
quit`)

  (first (peg/match solution-grammar (slurp "10.tmp.sol"))))

(defn solve-schematic [buttons schematic]
  (def m (length schematic))
  (def n (length buttons))
  (def f (file/open "10.tmp.lp" :w))
  (file/write f "MINIMIZE\n")
  (file/write f (format-with-sep (range n) "x%d" " + "))
  (file/write f "\nSUBJECT TO\n")
  (loop [[i constraint] :in (enumerate (linear-form buttons m))]
    (file/write f (string/format "c%d: " i))
    (file/write f (format-with-sep constraint "x%d" " + "))
    (file/write f (string/format " = %d\n" (schematic i))))
  (file/write f "GENERALS\n")
  (file/write f (format-with-sep (range n) "x%d" " "))
  (file/write f "\nEND\n")
  (file/close f)

  ($< scip < `read 10.tmp.lp
optimize
display solution
write solution 10.tmp.sol
quit`)

  (first (peg/match solution-grammar (slurp "10.tmp.sol"))))

(print "part 1: " (sum (seq [[lights buttons schematic] :in manual] (solve-lights lights buttons))))
(print "part 2: " (sum (seq [[lights buttons schematic] :in manual] (solve-schematic buttons schematic))))
