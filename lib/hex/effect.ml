type 'msg effect = { run : unit -> 'msg Xstream.stream }

let stream s = { run = (fun () -> s) }

let value v = { run = (fun () -> Xstream.from_value v) }

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
  let rec listener : 'msg effect Xstream.listener =
    {
      next =
        (fun eff ->
          let effect_stream = eff.run () in
          let rec effect_listener : 'msg Xstream.listener =
            {
              next =
                (fun effect ->
                  Xstream._producer_gen_next !effect_producer_gen effect);
              error = (fun err -> raise err);
              complete =
                (fun _ -> Xstream.remove_listener effect_stream effect_listener);
            }
          in
          Xstream.add_listener effect_stream  effect_listener);
      error = (fun err -> raise err);
      complete = (fun _ -> Xstream.remove_listener _effect_sink listener);
    }
  in
  let effect_source = effect_producer |> Xstream.create in
  Xstream.add_listener effect_source
    { next = (fun _ -> ()); error = (fun _ -> ()); complete = (fun _ -> ()) };
  Xstream.add_listener _effect_sink listener;
  effect_source
