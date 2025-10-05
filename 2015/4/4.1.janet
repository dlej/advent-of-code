(import "./build/md5" :as md5)

(defn md5 [str]
  (md5/md5 (array ;(string/bytes str))))

(defn md5-5-zeros? [str]
  (= "00000" (string/slice (md5 str) 0 5)))


(defn find-md5-5-zeros [prefix]
  (var i 1)
  (while (not (md5-5-zeros? (string/join [prefix (string/format "%d" i)])))
    (++ i))
  i)


(loop [line :in (string/split "\n" (slurp "4.txt"))]
  (printf "%s: %d" line (find-md5-5-zeros line)))
