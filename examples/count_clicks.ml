module Xs = Hex_ui.Xstream
module Dom = Hex_ui.Dom
module Attrs = Hex_ui.Attrs
module Events = Hex_ui.Events
module Run = Hex_ui.Run

let app dom_source _effect_source =
  let button_tag, button_events = Events.create_tag dom_source "count-button" in
  let clicks =
    button_events |> Events.on_click' |> Xs.fold (fun acc _ -> acc + 1) 0
  in
  let dom =
    clicks
    |> Xs.map (fun count ->
           Dom.button [ button_tag ]
             [| Dom.text ("Count: " ^ string_of_int count) |])
  in
  let sinks : unit Run.sinks = { Run.dom; Run.effects = Xs.empty () } in
  sinks
