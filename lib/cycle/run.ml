type driver
type source
type sink
type sources = source Js.Dict.t
type drivers = driver Js.Dict.t

type 'msg sinks = {
  dom : Dom.virtual_dom_node Xstream.stream;
  effects : 'msg Effect.effect Xstream.stream;
}

type 'msg main = Dom.dom_event_source -> 'msg Effect.effect_source -> 'msg sinks

external _lift_stream : 'msg Xstream.stream -> sink = "%identity"
external _lift_dom_driver : Dom.dom_driver -> driver = "%identity"
external _unlift_dom_driver : driver -> Dom.dom_driver = "%identity"
external _unlift_dom_source : source -> Dom.dom_event_source = "%identity"
external _lift_effect_driver : 'msg Effect.effect_driver -> driver = "%identity"

external _unlift_effect_driver : driver -> 'msg Effect.effect_driver
  = "%identity"

external _unlift_effect_source : source -> 'msg Effect.effect_source
  = "%identity"

external run : (sources -> sink Js.Dict.t) -> drivers -> unit = "run"
  [@@bs.module "@cycle/run"]

let _dom_source_sink_key = "DOM"
let _effect_source_sink_key = "effect"

let run_main (main : 'msg main) container_selector =
  let driver_config = Js.Dict.empty () in
  Js.Dict.set driver_config _dom_source_sink_key
    (Dom._make_dom_driver container_selector |> _lift_dom_driver);
  Js.Dict.set driver_config _effect_source_sink_key
    (Effect._make_effect_driver () |> _lift_effect_driver);
  run
    (fun sources ->
      let dom_source =
        Js.Dict.unsafeGet sources _dom_source_sink_key |> _unlift_dom_source
      in
      let effect_source : 'msg Xstream.stream =
        Js.Dict.unsafeGet sources _effect_source_sink_key
        |> _unlift_effect_source
      in
      let output = main dom_source effect_source in
      let sinks = Js.Dict.empty () in
      Js.Dict.set sinks _dom_source_sink_key (output.dom |> _lift_stream);
      Js.Dict.set sinks _effect_source_sink_key (output.effects |> _lift_stream);
      sinks)
    driver_config
