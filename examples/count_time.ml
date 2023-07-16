module Xs = Ocycl.Xstream
module Dom = Ocycl.Dom
module Run = Ocycl.Run
module Attrs = Ocycl.Attrs

let app =
  let tick = Xs.periodic 1000 |> Xs.map_to 1 |> Xs.fold (fun acc cur -> acc + cur) 0 in
  let dom =
    tick |> Xs.map (fun i -> Dom.h1 [] [| Dom.text (string_of_int i) |])
  in
  let sinks : unit Run.sinks = { dom; effects = Xs.empty () } in
  sinks
