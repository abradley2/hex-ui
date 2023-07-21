type virtual_dom_node
type dom_driver
type dom_source
type dom_source_selector
type node_data = { attrs : Attrs.attr Js.Dict.t }

external _make_dom_driver : string -> dom_driver = "makeDOMDriver"
  [@@bs.module "@cycle/dom"]

external text : string -> virtual_dom_node = "%identity"

external _dom_source_select' :
  dom_source -> string -> dom_source_selector = "select"
  [@@bs.send]

external _dom_source_selector_on' :
  dom_source_selector -> string -> 'event Xstream.stream = "events"
  [@@bs.send]

external h :
  string -> node_data -> virtual_dom_node Js.Array.t -> virtual_dom_node = "h"
  [@@bs.module "@cycle/dom"]

let element tag attrs children =
  h tag { attrs = Js.Dict.fromList attrs } children

let div attrs children = h "div" { attrs = Js.Dict.fromList attrs } children

let button attrs children =
  h "button" { attrs = Js.Dict.fromList attrs } children

let input attrs children = h "input" { attrs = Js.Dict.fromList attrs } children

let textarea attrs children =
  h "textarea" { attrs = Js.Dict.fromList attrs } children

let select attrs children =
  h "select" { attrs = Js.Dict.fromList attrs } children

let option attrs children =
  h "option" { attrs = Js.Dict.fromList attrs } children

let label attrs children = h "label" { attrs = Js.Dict.fromList attrs } children
let form attrs children = h "form" { attrs = Js.Dict.fromList attrs } children
let table attrs children = h "table" { attrs = Js.Dict.fromList attrs } children
let thead attrs children = h "thead" { attrs = Js.Dict.fromList attrs } children
let tbody attrs children = h "tbody" { attrs = Js.Dict.fromList attrs } children
let tr attrs children = h "tr" { attrs = Js.Dict.fromList attrs } children
let th attrs children = h "th" { attrs = Js.Dict.fromList attrs } children
let td attrs children = h "td" { attrs = Js.Dict.fromList attrs } children
let ul attrs children = h "ul" { attrs = Js.Dict.fromList attrs } children
let ol attrs children = h "ol" { attrs = Js.Dict.fromList attrs } children
let li attrs children = h "li" { attrs = Js.Dict.fromList attrs } children
let p attrs children = h "p" { attrs = Js.Dict.fromList attrs } children
let h1 attrs children = h "h1" { attrs = Js.Dict.fromList attrs } children
let h2 attrs children = h "h2" { attrs = Js.Dict.fromList attrs } children
let h3 attrs children = h "h3" { attrs = Js.Dict.fromList attrs } children
let h4 attrs children = h "h4" { attrs = Js.Dict.fromList attrs } children
let h5 attrs children = h "h5" { attrs = Js.Dict.fromList attrs } children
let h6 attrs children = h "h6" { attrs = Js.Dict.fromList attrs } children
let span attrs children = h "span" { attrs = Js.Dict.fromList attrs } children
let img attrs children = h "img" { attrs = Js.Dict.fromList attrs } children
let a attrs children = h "a" { attrs = Js.Dict.fromList attrs } children
let nav attrs children = h "nav" { attrs = Js.Dict.fromList attrs } children

let header attrs children =
  h "header" { attrs = Js.Dict.fromList attrs } children

let footer attrs children =
  h "footer" { attrs = Js.Dict.fromList attrs } children

let section attrs children =
  h "section" { attrs = Js.Dict.fromList attrs } children

let article attrs children =
  h "article" { attrs = Js.Dict.fromList attrs } children

let aside attrs children = h "aside" { attrs = Js.Dict.fromList attrs } children
let b attrs children = h "b" { attrs = Js.Dict.fromList attrs } children
let i attrs children = h "i" { attrs = Js.Dict.fromList attrs } children
