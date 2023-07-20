module Xs = Ocycl.Xstream
module Run = Ocycl.Run
module Dom = Ocycl.Dom
module Attrs = Ocycl.Attrs
module Effect = Ocycl.Effect
module Count_time = Examples.Count_time
module Count_clicks = Examples.Count_clicks
module Trigger_effect = Examples.Trigger_effect
module Components = Examples.Components

let main dom_source effect_source =
  let { Run.dom = count_time_dom; _ } =
    Count_time.app dom_source effect_source
  in
  let { Run.dom = count_clicks_dom; _ } =
    Count_clicks.app dom_source effect_source
  in
  let { Run.dom = trigger_effect_dom; effects = trigger_effect_effects } =
    Trigger_effect.app dom_source effect_source
  in
  let { Run.dom = components_dom; _ } =
    Components.app dom_source effect_source
  in
  let dom =
    Xs.combine4 count_time_dom count_clicks_dom trigger_effect_dom
      components_dom
    |> Xs.map (fun (count_time, count_clicks, trigger_effect, components) ->
           Dom.div []
             [|
               Dom.div [] [| count_time |];
               Dom.div [] [| count_clicks |];
               Dom.div [] [| trigger_effect |];
               Dom.div [] [| components |];
             |])
  in
  let sinks : unit Run.sinks =
    { Run.dom; Run.effects = trigger_effect_effects }
  in
  sinks

let docs _dom_source _effect_source =
  let state = Xs.empty () |> Xs.start_with () in

  let dom =
    state
    |> Xs.map (fun _ ->
           Dom.div
             [ Attrs.class_ "vh-100 vw-100 bg-orange" ]
             [| Dom.text "Hello, welcome to Hex" |])
  in
  { Run.dom; Run.effects = Xs.empty () }

let () = Run.run_main docs "#app"
