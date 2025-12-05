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

(defn num-blocking [i j]
  (count |(= "@" (gget diagram ;$)) (gneighbors i j)))

# create a forklift bot at each location that waits until
# the roll is unblocked (checked after any neighboring
# roll is removed)

# create a channel for each bot that can hold one message
(def bot-chans (map |(seq [_ :in $] (ev/chan 1)) diagram))
(var removals 0)

# set up bots to remove rolls or wait for communication
(defn forklift-bot [i j]
  (when (= "@" (gget diagram i j))
    (while true
      (let [n (num-blocking i j)]
        (when (< n 4)
          (++ removals)
          (put (diagram i) j ".")
          (loop [[ii jj] :in (gneighbors i j)
                 :let [chan (gget bot-chans ii jj)]
                 :unless (nil? chan)
                 # if the neighbor already has a signal,
                 # don't write or else it'll block
                 :unless (< 0 (ev/count chan))]
            (ev/give chan 1))
          # exit after removal
          (break))
        (ev/take (gget bot-chans i j))))))

(def all-ij (seq [i :range [0 (length diagram)]
                  j :range [0 (length (diagram 0))]]
              [i j]))

(defn accessible? [i j]
  (and (= "@" (gget diagram i j))
       (> 4 (num-blocking i j))))

(print "part 1: " (count |(accessible? ;$) all-ij))

# launch all of the forklift bots concurrently
(loop [[i j] :in all-ij]
  (ev/call forklift-bot i j))

# wait until yielding control back to the bots
# doesn't result in any removals
(var check-val removals)
(ev/sleep 0)
(while (not= check-val removals)
  (set check-val removals)
  (ev/sleep 0))

(print "part 2: " removals)
(os/exit 0)
