module Xs = Ocycl.Xstream
module Dom = Ocycl.Dom
module Run = Ocycl.Run
module Attrs = Ocycl.Attrs

let app _ _ =
  let tick = Xs.periodic 1000 |> Xs.fold (fun acc _ -> acc + 1) 0 in
  let dom =
    tick |> Xs.map (fun i -> Dom.h1 [] [| Dom.text (string_of_int i) |])
  in
  let sinks : unit Run.sinks = { Run.dom; Run.effects = Xs.empty () } in
  sinks
