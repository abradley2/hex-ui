type element
type event

external document : element = "document" [@@bs.val]
external body : element = "body" [@@bs.val] [@@bs.scope "document"]

external request_animation_frame : (unit -> unit) -> unit
  = "requestAnimationFrame"
  [@@bs.val]

external _push_url : 'any Option.t -> string -> string -> unit = "pushState"
  [@@bs.val] [@@bs.scope "window", "history"]

let push_url url = _push_url None "" url

external _new_url : string -> 'url = "URL" [@@bs.new] [@@bs.scope "window"]

let new_url raw_url = try Ok (_new_url raw_url) with _ -> Error "Invalid URL"

external location : 'url = "location" [@@bs.val] [@@bs.scope "window"]
external origin : string = "origin" [@@bs.val] [@@bs.scope "window", "location"]
external tag_name : element -> string = "tagName" [@@bs.get]

external _parent_element : element -> element Js.nullable = "parentElement"
  [@@bs.get]

let parent_element e = _parent_element e |> Js.toOption

external target : event -> element = "target" [@@bs.get]

external add_event_listener : element -> string -> (event -> unit) -> unit
  = "addEventListener"
  [@@bs.send]

external prevent_default : event -> unit = "preventDefault" [@@bs.send]

external _get_attribute : element -> string -> string Js.nullable
  = "getAttribute"
  [@@bs.send]

let get_attribute element attribute =
  _get_attribute element attribute |> Js.toOption

let rec on_body_click cb event el =
  let tag_name = tag_name el in
  if tag_name == "A" then
    let is_link = get_attribute el "data-link" in
    let a_href = get_attribute el "href" |> Option.value ~default:"" in
    match is_link with
    | Some _ ->
        prevent_default event;
        push_url a_href;
        request_animation_frame (fun _ -> cb ())
    | None -> (
        match parent_element el with
        | Some el' -> on_body_click cb event el'
        | None -> ())
  else
    match parent_element el with
    | Some el' -> on_body_click cb event el'
    | None -> ()

let intercept_clicks cb =
  add_event_listener body "click" (fun event ->
      target event |> on_body_click cb event)

let url_producer : 'url Xstream._producer =
  {
    start =
      (fun producer_gen ->
        intercept_clicks (fun _ ->
            Xstream._producer_gen_next producer_gen location));
    stop = (fun _ -> ());
  }
