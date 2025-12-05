(def diagram
  (peg/match
    '{:main (some (group (* (some (<- :S)) :s*)))}
    (slurp "input")))

(defn gget [g & idx]
  (if (empty? idx) g
    (let [[i & rest] idx
          g- (get g i)]
      (if (nil? g-) nil (gget g- ;rest)))))

(defn gneighbors [i j]
  (seq [di :range-to [-1 1]
        dj :range-to [-1 1]
        :when (not= [di dj] [0 0])]
    [(+ i di) (+ j dj)]))

(defn pgrid [g]
  (loop [row :in g
         :after (print)
         c :in row]
    (prin c)))

(def all-ij (seq [i :range [0 (length diagram)]
                  j :range [0 (length (diagram 0))]]
              [i j]))

(defn accessible? [i j]
  (and (= "@" (gget diagram i j))
       (> 4 (count |(= "@" $) (map |(gget diagram ;$) (gneighbors i j))))))

(var removable-rolls (filter |(accessible? ;$) all-ij))
(print "part 1: " (length removable-rolls))

(var removed 0)
(while (not (empty? removable-rolls))
  (loop
    [[i j] :in removable-rolls]
    (put (diagram i) j ".")
    (++ removed))
  (set removable-rolls (filter |(accessible? ;$) all-ij)))

(print "part 2: " removed)
