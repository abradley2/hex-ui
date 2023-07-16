module Xs = Ocycl.Xstream
module Run = Ocycl.Run
module Dom = Ocycl.Dom
module Effect = Ocycl.Effect
module Count_time = Examples.Count_time
module Count_clicks = Examples.Count_clicks

let main dom_source _effect_source = 
  let { Run.dom = count_time_dom; _ } = Count_time.app in 
  let { Run.dom = count_clicks_dom; _ } = Count_clicks.app dom_source in
  let dom = 
      Xs.combine count_time_dom count_clicks_dom 
        |> Xs.map (fun (count_time, count_clicks) ->
            Dom.div 
              []
              [| Dom.div [] [| count_time |]
               ; Dom.div [] [| count_clicks |]
              |]
          ) in
  let sinks : unit Run.sinks = { Run.dom = dom; Run.effects = Xs.empty () } in
  sinks


let () = Run.run_main main "#app"
