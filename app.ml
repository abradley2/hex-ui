module Xs = Cycle.Xstream
module Run = Cycle.Run
module Dom = Cycle.Dom
module Effect = Cycle.Effect
module Count_time = Examples.Count_time

let main _dom_event_source _effect_event_source = Count_time.app
let () = Run.run_main main "#app"
