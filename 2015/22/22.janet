# Magic Missile costs 53 mana. It instantly does 4 damage.
# Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
# Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
# Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active, it deals the boss 3 damage.
# Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is active, it gives you 101 new mana.

(def [bhp bd]
  (peg/match
    '{:main (* "Hit Points:" :s+ (number :d+) :s* "Damage:" :s+ (number :d+))}
    (slurp "input")))

(def spells
  {:magic-missile
   {:cost 53
    :start (fn [[php pmp pa bhp bd]]
             [php pmp pa (- bhp 4) bd])}
   :drain
   {:cost 73
    :start (fn [[php pmp pa bhp bd]]
             [(+ php 2) pmp pa (- bhp 2) bd])}
   :shield
   {:cost 113
    :duration 6
    :start (fn [[php pmp pa bhp bd]]
             [php pmp (+ pa 7) bhp bd])
    :end (fn [[php pmp pa bhp bd]]
           [php pmp (- pa 7) bhp bd])}
   :poison
   {:cost 173
    :duration 6
    :turn (fn [[php pmp pa bhp bd]]
            [php pmp pa (- bhp 3) bd])}
   :recharge
   {:cost 229
    :duration 5
    :turn (fn [[php pmp pa bhp bd]]
            [php (+ pmp 101) pa bhp bd])}})

(defn do-effects [state &opt new-spell-name]
  (var stats (state :stats))
  (def effects (struct/to-table (state :effects)))
  (loop [[name dur] :pairs (state :effects)
         :let [dur (dec dur)
               sp (spells name)]]
    (when (sp :turn)
      (set stats ((sp :turn) stats)))
    (put effects name dur)
    (when (= dur 0)
      (put effects name nil)
      (if (sp :end)
        (set stats ((sp :end) stats)))))
  (when new-spell-name
    (let [spell (spells new-spell-name)
          [php pmp pa bhp bd] stats]
      (if (< pmp (spell :cost))
        (error "not enough mana"))
      (if (effects new-spell-name)
        (error "already have effect"))
      (set stats [php (- pmp (spell :cost)) pa bhp bd])
      (if (spell :duration)
        (put effects new-spell-name (spell :duration)))
      (when (spell :start)
        (set stats ((spell :start) stats)))))
  {:stats stats :effects (table/to-struct effects)})

(defn full-round [state spell-name]
  (def state (do-effects state spell-name))
  (def bhp ((state :stats) 3))
  (if (<= bhp 0)
    :player
    (let [state (do-effects state)
          [php pmp pa bhp bd] (state :stats)]
      (if (<= bhp 0)
        :player
        (do
          (def php (- php (max 1 (- bd pa))))
          (if (<= php 0)
            :boss
            {:stats [php pmp pa bhp bd]
             :effects (state :effects)}))))))

# (var state {:stats [10 250 0 13 8] :effects {}})
# (loop [name :in [:poison :magic-missile]]
#   (set state (full-round state name))
#   (pp state))

(var state {:stats [10 250 0 14 8] :effects {}})
(loop [name :in [:recharge :shield :drain :poison :magic-missile]]
  (set state (full-round state name))
  (pp state))

(use daniel)

(defn neighbor-fn [state-wrapper]
  (seq [:let [state (state-wrapper :state)]
        name :keys spells
        :let [next-state (try (full-round state name) ([_] nil))]
        :unless (nil? next-state)]
    [{:state next-state :spell name} ((spells name) :cost)]))

(def stats [50 500 0 bhp bd])
(def best (a-star {:state {:stats stats :effects {}}} |(= ($ :state) :player) neighbor-fn))
(def best-cost
  (sum (seq [{:spell name} :in best :when name]
         ((spells name) :cost))))
(print "part 1: " best-cost)


(defn full-round-hard [state spell-name]
  (def [php pmp pa bhp bd] (state :stats))
  (def php (dec php))
  (if (<= php 0)
    :boss
    (let [state (do-effects {:stats [php pmp pa bhp bd]
                             :effects (state :effects)} spell-name)
          bhp ((state :stats) 3)]
      (if (<= bhp 0)
        :player
        (let [state (do-effects state)
              [php pmp pa bhp bd] (state :stats)]
          (if (<= bhp 0)
            :player
            (do
              (def php (- php (max 1 (- bd pa))))
              (if (<= php 0)
                :boss
                {:stats [php pmp pa bhp bd]
                 :effects (state :effects)}))))))))

(defn neighbor-fn-hard [state-wrapper]
  (seq [:let [state (state-wrapper :state)]
        name :keys spells
        :let [next-state (try (full-round-hard state name) ([_] nil))]
        :unless (nil? next-state)]
    [{:state next-state :spell name} ((spells name) :cost)]))

(def stats [50 500 0 bhp bd])
(def best (a-star {:state {:stats stats :effects {}}} |(= ($ :state) :player) neighbor-fn-hard))
(def best-cost
  (sum (seq [{:spell name} :in best :when name]
         ((spells name) :cost))))
(print "part 2: " best-cost)
