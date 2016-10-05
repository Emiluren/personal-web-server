(require '[cljs.build.api :as b])

(b/watch "src"
  {:main 'chatt_app.core
   :output-to "priv/static/js/cljs/chatt_app.js"
   :output-dir "priv/static/js/cljs"
   :output-dir "/js/cljs"})
