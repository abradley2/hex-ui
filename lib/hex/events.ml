let on event dom_source_selector =
  Dom._dom_source_selector_on' dom_source_selector event

let target selector dom_source =
  Dom._dom_source_select' dom_source selector

let create_tag dom_source tag =
  ( Attrs.tag tag,
    dom_source |> target (String.concat "" [ "[data-tag=\""; tag; "\"]" ])
  )

let _get_value element =
  Js.Dict.get element "target" |> fun next ->
  Option.bind next (fun target -> Js.Dict.get target "value")
  |> Option.value ~default:""

let on_input (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "input" |> Xstream.map _get_value

let on_input' (selector : Dom.dom_source_selector) : string Xstream.stream
    =
  on "input" selector |> Xstream.map _get_value

let on_change (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "change"

let on_change' (selector : Dom.dom_source_selector) :
    unit Xstream.stream =
  on "change" selector

let on_click (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "click"

let on_click' (event_selector : Dom.dom_source_selector) :
    unit Xstream.stream =
  on "click" event_selector

let on_submit (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "submit"

let on_keydown (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "keydown"

let on_keyup (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "keyup"

let on_keypress (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "keypress"

let on_mousedown (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "mousedown"

let on_mouseup (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "mouseup"

let on_mousemove (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "mousemove"

let on_mouseover (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "mouseover"

let on_mouseout (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "mouseout"

let on_mouseenter (dom_source : Dom.dom_source) (selector : string)
    : unit Xstream.stream =
  target selector dom_source |> on "mouseenter"

let on_mouseleave (dom_source : Dom.dom_source) (selector : string)
    : unit Xstream.stream =
  target selector dom_source |> on "mouseleave"

let on_touchstart (dom_source : Dom.dom_source) (selector : string)
    : unit Xstream.stream =
  target selector dom_source |> on "touchstart"

let on_touchend (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "touchend"

let on_touchmove (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "touchmove"

let on_touchcancel (dom_source : Dom.dom_source) (selector : string)
    : unit Xstream.stream =
  target selector dom_source |> on "touchcancel"

let on_dragstart (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "dragstart"

let on_drag (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "drag"

let on_dragenter (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "dragenter"

let on_dragleave (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "dragleave"

let on_dragover (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "dragover"

let on_drop (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "drop"

let on_dragend (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "dragend"

let on_focus (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "focus"

let on_focus' (event_selector : Dom.dom_source_selector) :
    unit Xstream.stream =
  on "focus" event_selector

let on_blur (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "blur"

let on_blur' (event_selector : Dom.dom_source_selector) :
    unit Xstream.stream =
  on "blur" event_selector

let on_focusin (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "focusin"

let on_focusout (dom_source : Dom.dom_source) (selector : string) :
    unit Xstream.stream =
  target selector dom_source |> on "focusout"

let on_scroll (dom_source : Dom.dom_source) (selector : string) :
    string Xstream.stream =
  target selector dom_source |> on "scroll"
