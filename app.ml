module Xs = Hex_ui.Xstream
module Run = Hex_ui.Run
module Dom = Hex_ui.Dom
module Attrs = Hex_ui.Attrs
module Effect = Hex_ui.Effect
module Count_time = Examples.Count_time
module Count_clicks = Examples.Count_clicks
module Trigger_effect = Examples.Trigger_effect
module Effect_mapping = Examples.Effect_mapping
module Components = Examples.Components

type effect =
  | Init of unit
  | TriggerEffect of unit
  | EffectA of Effect_mapping.msgA
  | EffectB of Effect_mapping.msgB

let main dom_source effect_source =
  let { Run.dom = count_time_dom; _ } =
    Count_time.app dom_source effect_source
  in
  let { Run.dom = count_clicks_dom; _ } =
    Count_clicks.app dom_source effect_source
  in
  let { Run.dom = trigger_effect_dom; effects = trigger_effect_effects } =
    Trigger_effect.app dom_source effect_source
    |> Run.map_sinks (fun msg -> TriggerEffect msg)
  in
  let { Run.dom = effect_mapping_a_dom; Run.effects = effect_mapping_a_effects }
      =
    Effect_mapping.component_a dom_source
      (effect_source
      |> Xs.select_map (fun msg ->
             match msg with EffectA subMsg -> Some subMsg | _ -> None))
    |> Run.map_sinks (fun msg -> EffectA msg)
  in
  let { Run.dom = effect_mapping_b_dom; Run.effects = effect_mapping_b_effects }
      =
    Effect_mapping.component_b dom_source
      (effect_source
      |> Xs.select_map (fun msg ->
             match msg with EffectB subMsg -> Some subMsg | _ -> None))
    |> Run.map_sinks (fun msg -> EffectB msg)
  in
  let { Run.dom = components_dom; _ } =
    Components.app dom_source effect_source
  in
  let dom =
    Xs.combine6 count_time_dom count_clicks_dom trigger_effect_dom
      components_dom effect_mapping_a_dom effect_mapping_b_dom
    |> Xs.map
         (fun
           ( count_time,
             count_clicks,
             trigger_effect,
             components,
             effect_mapping_a,
             effect_mapping_b )
         ->
           Dom.div []
             [|
               Dom.div [] [| count_time |];
               Dom.div [] [| count_clicks |];
               Dom.div [] [| trigger_effect |];
               Dom.div [] [| components |];
               Dom.div [] [| effect_mapping_a |];
               Dom.div [] [| effect_mapping_b |];
             |])
  in
  let sinks : effect Run.sinks =
    {
      Run.dom;
      Run.effects =
        trigger_effect_effects
        |> Xs.merge effect_mapping_a_effects
        |> Xs.merge effect_mapping_b_effects;
    }
  in
  sinks

let () =
  Run.run_main main ~container_selector:"#app" ~on_location_changed:(fun _ ->
      Init ())
