module Xs = Ocycl.Xstream
module Run = Ocycl.Run
module Dom = Ocycl.Dom
module Effect = Ocycl.Effect
module Count_time = Examples.Count_time

let main _dom_event_source _effect_event_source = Count_time.app
let () = Run.run_main main "#app"
