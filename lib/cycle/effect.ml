type 'msg effect = { run : unit -> 'msg Xstream.stream }

let map fn effect = { run = (fun () -> effect.run () |> Xstream.map fn) }

exception FailedToComplete of string
exception UnhandledEffect of string

type 'msg effect_driver = 'msg effect Xstream.stream -> 'msg Xstream.stream
type 'msg effect_source = 'msg Xstream.stream

let _make_effect_driver () _effect_sink =
  let default_producer_gen : 'msg Xstream._producer_gen =
    {
      next =
        (fun _ ->
          raise
            (UnhandledEffect "Msg was produced before Effect could be handled"));
    }
  in
  let effect_producer_gen = ref default_producer_gen in
  let effect_producer : 'msg Xstream._producer =
    {
      start =
        (fun _effect_producer_next ->
          effect_producer_gen := _effect_producer_next;
          ());
      stop =
        (fun _ ->
          effect_producer_gen := default_producer_gen;
          ());
    }
  in
  let subscription_ref = ref None in
  let listener : 'msg effect Xstream.listener =
    {
      next =
        (fun eff ->
          let effect_subscription_ref = ref None in
          let effect_listener : 'msg Xstream.listener =
            {
              next =
                (fun effect ->
                  Xstream._producer_gen_next !effect_producer_gen effect);
              error = (fun err -> raise err);
              complete =
                (fun _ ->
                  match !effect_subscription_ref with
                  | Some subscription -> subscription |> Xstream.unsubscribe
                  | None -> raise (FailedToComplete "Failed to unsubscribe"));
            }
          in
          effect_subscription_ref :=
            Some (eff.run () |> Xstream.subscribe effect_listener));
      error = (fun err -> raise err);
      complete =
        (fun _ ->
          match !subscription_ref with
          | Some subscription -> subscription |> Xstream.unsubscribe
          | None -> raise (FailedToComplete "Failed to unsubscribe"));
    }
  in
  subscription_ref := Some (_effect_sink |> Xstream.subscribe listener);
  effect_producer |> Xstream.create
