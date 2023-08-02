open Hex.Run
open Hex.Dom
open Hex.Xstream

let app _ _ =
  let state = periodic 1000 |> fold (fun acc _ -> acc + 1) 0 in
  let view state' = h1 [] [| text (string_of_int state') |] in
  let dom = state |> map view in
  let effects = empty () in
  ({ dom; effects } : unit sinks)
