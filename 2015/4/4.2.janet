(import "./build/md5" :as md5)

(defn md5 [str]
  (md5/md5 (array ;(string/bytes str))))

(defn md5-6-zeros? [str]
  (= "000000" (string/slice (md5 str) 0 6)))


(defn find-md5-6-zeros [prefix]
  (var i 1)
  (while (not (md5-6-zeros? (string/join [prefix (string/format "%d" i)])))
    (++ i))
  i)


(loop [line :in (string/split "\n" (slurp "4.txt"))]
  (printf "%s: %d" line (find-md5-6-zeros line)))
