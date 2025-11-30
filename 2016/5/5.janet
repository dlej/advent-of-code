(import "../../2015/4/build/md5" :as md5)

(defn md5 [str]
  (md5/md5 (array ;(string/bytes str))))

(defn find-password [door-id]
  (var i 0)
  (var hsh nil)
  (string/join
    (seq [_ :range [0 8]]
      (while (not (string/has-prefix?
                    "00000"
                    (set hsh (md5 (string/format "%s%d" door-id i)))))
        (++ i))
      (++ i)
      (string/slice hsh 5 6))))

(prin "part 1: ")
(def door-id (slurp "input"))
(print (find-password door-id))

(defn find-second-password [door-id]
  (var i 0)
  (var hsh nil)
  (def chars @{})
  (while (< (length chars) 8)
    (while (not (string/has-prefix?
                  "00000"
                  (set hsh (md5 (string/format "%s%d" door-id i)))))
      (++ i))
    (++ i)
    (let [j (scan-number (string/slice hsh 5 6) 16)
          v (string/slice hsh 6 7)]
      (when (and (< j 8) (not (in chars j)))
        (put chars j v))))
  (string/join (seq [i :range [0 8]] (chars i))))

(prin "part 2: ")
(print (find-second-password door-id))
