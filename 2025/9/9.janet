(def red-tiles
  (peg/match
    '{:line (group (* (number :d+) "," (number :d+) :s*))
      :main (some :line)}
    (slurp "input")))

(defn area [u v]
  (* (inc (math/abs (- (u 0) (v 0)))) (inc (math/abs (- (u 1) (v 1))))))

(use daniel)
(def areas
  (sorted
    (seq [[i pi] :in (enumerate red-tiles)
          j :range [(inc i) (length red-tiles)]]
      [(area pi (red-tiles j)) i j])))

(print "part 1: " (first (last areas)))


(defn get-extent [tups]
  (if (empty? tups) nil
    (let [[tup & tups] (sorted tups)]
      (var [left right] tup)
      (prompt :ret
        (loop [[l r] :in tups]
          (if (<= l (inc right))
            (set right r)
            (return :ret nil)))
        [left right]))))

(loop [[a i j] :in (reverse areas)
       :let [[xi yi] (red-tiles i)
             [xj yj] (red-tiles j)
             top (min yi yj)
             bottom (max yi yj)
             left (min xi xj)
             right (max xi xj)]]

  (let [tiles @[]
        edges {:top @[] :bottom @[] :left @[] :right @[]}]

    # project all vertices
    (loop [[x y] :in red-tiles
           :let [tile
                 [(min (max x left) right)
                  (min (max y top) bottom)]]
           :unless (= (last tiles) tile)]
      (array/push tiles tile))

    # collect all edges
    (loop [[i [xi yi]] :in (enumerate tiles)
           :let [j (mod (inc i) (length tiles))
                 [xj yj] (tiles j)]]
      (if (= top yi yj) (array/push (edges :top) (tuple/slice (sorted [xi xj]))))
      (if (= bottom yi yj) (array/push (edges :bottom) (tuple/slice (sorted [xi xj]))))
      (if (= left xi xj) (array/push (edges :left) (tuple/slice (sorted [yi yj]))))
      (if (= right xi xj) (array/push (edges :right) (tuple/slice (sorted [yi yj])))))

    # check all edges
    (when (and
            (= [left right] (get-extent (edges :top)) (get-extent (edges :bottom)))
            (= [top bottom] (get-extent (edges :left)) (get-extent (edges :right))))

      (print "part 2: " a)
      (os/exit 0))))
