(defproject chatt_app "0.1.0-SNAPSHOT"
  :description "FIXME: write this!"
  :url "http://example.com/FIXME"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/clojurescript "1.9.229"]
                 [org.omcljs/om "1.0.0-alpha38"]
                 [figwheel-sidecar "0.5.4-7" :scope "test"]
                 [cljs-ajax "0.5.8"]
                 [sablono "0.7.2"]]

  :jvm-opts ^:replace ["-Xmx1g" "-server"]
  :plugins [[lein-npm "0.6.1"]]
  :npm {:dependencies [[source-map-support "0.4.0"]]}
  :source-paths ["src" "target/classes"]
  :clean-targets ["priv/static/js/cljs" "priv/static/js/cljs-adv"]
  :target-path "target")
