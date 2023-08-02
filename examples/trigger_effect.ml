module Xs = Hex.Xstream
module Dom = Hex.Dom
module Run = Hex.Run
module Attrs = Hex.Attrs
module Events = Hex.Events
module Effect = Hex.Effect

type element

external document : element = "document" [@@bs.val]

external get_element_by_id : element -> string -> element = "getElementById"
  [@@bs.send]

external focus_element : element -> unit = "focus" [@@bs.send]

let app dom_source _effect_source =
  let button_tag, button_events =
    Events.create_tag dom_source "trigger-effect-btn"
  in
  let clicks = button_events |> Events.on_click' in
  let effects =
    clicks
    |> Xs.map (fun _ ->
           {
             Effect.run =
               (fun () ->
                 get_element_by_id document "focus-me" |> focus_element;
                 Xs.periodic 1000 |> Xs.map_to ());
           })
  in
  let dom =
    Dom.div []
      [|
        Dom.button [ button_tag ] [| Dom.text "Focus input" |];
        Dom.input [ Attrs.id "focus-me" ] [||];
      |]
    |> Xs.from_value
  in

  let sinks : unit Run.sinks = { dom; effects } in
  sinks
