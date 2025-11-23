(def [bhp bd ba]
  (peg/match
    '{:main (* "Hit Points:" :s+ (number :d+) :s* "Damage:" :s+ (number :d+) :s* "Armor:" :s+ (number :d+))}
    (slurp "21.txt")))

(def [weapons armor rings]
  (peg/match
    '{:rest-of-line (* (any (if-not "\n" 1)) "\n")
      :name (<- (* :w+ (? (* :s :S+))))
      :row (group (* :name :s+ (number :d+) :s+ (number :d+) :s+ (number :d+) :s*))
      :weapons (group (* "Weapons:" :rest-of-line (any :row)))
      :armor (group (* "Armor: " :rest-of-line (any :row)))
      :rings (group (* "Rings: " :rest-of-line (any :row)))
      :main (* :weapons :armor :rings)}
    (slurp "shop.txt")))

(defn play [php pd pa bhp bd ba]
  (var php php)
  (var bhp bhp)
  (while (and (< 0 php) (< 0 bhp))
    (let [phit (max 1 (- pd ba))
          bhit (max 1 (- bd pa))]
      (-= bhp phit)
      (if (< 0 bhp)
        (-= php bhit))))
  (if (< 0 php)
    :player
    :boss))

(defn choose [n k]
  (case k
    0 @[[]]
    1 (seq [i :range [0 n]] [i])
    (seq [i :range [0 n]
          :let [sub-choose (choose (- n i 1) (dec k))]
          rest :in sub-choose]
      (tuple i ;(map |(+ i $ 1) rest)))))

(defn choose-all [n ks]
  (catseq [k :in ks] (choose n k)))

(defn sum-stats [& equip]
  (tuple ;(seq [i :range-to [1 3]] (sum (map |($ i) equip)))))

(def php 100)
(print "part 1: " (min-of (seq [w :in weapons
                                i_s :in (choose-all (length armor) [0 1])
                                :let [as (map |(armor $) i_s)]
                                j_s :in (choose-all (length rings) [0 1 2])
                                :let [rs (map |(rings $) j_s)
                                      [pc pd pa] (sum-stats w ;as ;rs)]
                                :when (= (play php pd pa bhp bd ba) :player)]
                            pc)))

(print "part 2: " (max-of (seq [w :in weapons
                                i_s :in (choose-all (length armor) [0 1])
                                :let [as (map |(armor $) i_s)]
                                j_s :in (choose-all (length rings) [0 1 2])
                                :let [rs (map |(rings $) j_s)
                                      [pc pd pa] (sum-stats w ;as ;rs)]
                                :when (= (play php pd pa bhp bd ba) :boss)]
                            pc)))
