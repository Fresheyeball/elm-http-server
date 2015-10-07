(defn- sanitize
  [record & spaces]
  (spaces.reduce (fn [r space] (do
    (if (aget r space) nil (set! (aget r space) {}))
    (aget r space)))
  record))

(defn- readFile
  [fs Task]
  (fn [path] (.asyncFunction Task (fn [callback]
    (.readFile fs path (fn [err, data]
      (callback
        (if err
          (Task.fail err)
          (Task.succeed data)))))))))

(defn- make
  [localRuntime] (let
  [fs (require "fs")
   Task (Elm.Native.Task.make localRuntime)]
  (do (sanitize localRuntime :Native :FS)
    (let [v localRuntime.Native.FS.values]
      (if v v (set! localRuntime.Native.FS.values {
        :readFile (readFile fs Task)}))))))

(sanitize Elm :Native :FS)
(set! Elm.Native.FS.make make)

(if (== (typeof window) :undefined) (set! window global))
