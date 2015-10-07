(defn- sanitize
  [record & spaces]
  (spaces.reduce (fn [r space] (do
    (if (aget r space) nil (set! (aget r space) {}))
    (aget r space)))
  record))

(defn- make
  [localRuntime] (let
  [Task (Elm.Native.Task.make localRuntime)]
  (do (sanitize localRuntime :Native :VDOMtoHTML)
    (let [v localRuntime.Native.VDOMtoHTML.values]
      (if v v (set! localRuntime.Native.VDOMtoHTML.values {
        :toHTML (require :vdom-to-html)}))))))

(sanitize Elm :Native :VDOMtoHTML)
(set! Elm.Native.VDOMtoHTML.make make)

(if (== (typeof window) :undefined) (set! window global))
