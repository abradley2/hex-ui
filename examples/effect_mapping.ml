module Run = Hex_ui.Run
module Dom = Hex_ui.Dom
module Xs = Hex_ui.Xstream
module Effect = Hex_ui.Effect

type msgA = MsgA of int

let component_a _dom_source effect_source =
  let dom_sink =
    effect_source |> Xs.start_with (MsgA 0)
    |> Xs.map (fun msg ->
           match msg with
           | MsgA v -> Dom.button [] [| string_of_int v |> Dom.text |])
  in
  let effect_sink = MsgA 1 |> Effect.value |> Xs.from_value in
  { Run.dom = dom_sink; Run.effects = effect_sink }

type msgB = MsgB of int

let component_b _dom_source effect_source =
  let dom_sink =
    effect_source |> Xs.start_with (MsgB 0)
    |> Xs.map (fun msg ->
           match msg with
           | MsgB v -> Dom.button [] [| string_of_int v |> Dom.text |])
  in
  let effect_sink = MsgB 2 |> Effect.value |> Xs.from_value in
  { Run.dom = dom_sink; Run.effects = effect_sink }
