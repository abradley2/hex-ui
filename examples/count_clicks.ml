module Xs = Hex_ui.Xstream
module Events = Hex_ui.Events
module Run = Hex_ui.Run

let app dom_source _ =
  let button_tag, button_events = Events.create_tag dom_source "count-button" in
  let clicks =
    Events.on_click' button_events |> Xs.fold (fun acc _ -> acc + 1) 0
  in
  let dom =
    let open Hex_ui.Dom in
    clicks
    |> Xs.map (fun count ->
           button [ button_tag ]
             [| text ("Count is : " ^ string_of_int count) |])
  in
  { Run.dom; Run.effects = Xs.empty () }
