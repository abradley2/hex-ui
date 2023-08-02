type 'msg stream

type 'msg listener = {
  next : 'msg -> unit;
  error : exn -> unit;
  complete : unit -> unit;
}

type 'msg _producer_gen = { next : 'msg -> unit }

external _producer_gen_next : 'msg _producer_gen -> 'msg -> unit = "next"
  [@@bs.send]

type 'msg _produce_start_func = 'msg _producer_gen -> unit
type _producer_stop_func = unit -> unit

type 'msg _producer = {
  start : 'msg _produce_start_func;
  stop : _producer_stop_func;
  id : int;
}

external create : 'msg _producer -> 'msg stream = "create"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external add_listener : 'msg stream -> 'msg listener -> unit = "addListener"
  [@@bs.send]

external remove_listener : 'msg stream -> 'msg listener -> unit
  = "removeListener"
  [@@bs.send]

external start_with' : 'msg stream -> 'msg -> 'msg stream = "startWith"
  [@@bs.send]

let start_with msg stream = start_with' stream msg

external fold' :
  'msg stream -> ('state -> 'msg -> 'state) -> 'state -> 'state stream = "fold"
  [@@bs.send]

let fold fn init stream = fold' stream fn init

external take' : 'msg stream -> int -> 'msg stream = "take" [@@bs.send]

let take n stream = take' stream n

external drop' : 'msg stream -> int -> 'msg stream = "drop" [@@bs.send]

let drop n stream = drop' stream n

external remember : 'msg stream -> 'msg stream = "remember" [@@bs.send]

external map' : 'msg stream -> ('msg -> 'next_msg) -> 'next_msg stream = "map"
  [@@bs.send]

let map fn a = map' a fn

external map_to' : 'msg stream -> 'next_msg -> 'next_msg stream = "mapTo"
  [@@bs.send]

let map_to a b = map_to' b a

external flatten : 'msg stream stream -> 'msg stream = "flatten" [@@bs.send]

let flat_map f stream = stream |> map f |> flatten

type subscription

external unsubscribe : subscription -> unit = "unsubscribe" [@@bs.send]

external subscribe' : 'msg stream -> 'msg listener -> subscription = "subscribe"
  [@@bs.send]

let subscribe f stream = subscribe' stream f

external from_value : 'msg -> 'msg stream = "of"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external from_array : 'msg array -> 'msg stream = "fromArray"
  [@@bs.module "xstream"] [@@bs.scope "default"]

let empty () = from_array [||]

external periodic : int -> int stream = "periodic"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external from_promise : 'msg Js.Promise.t -> 'msg stream = "fromPromise"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external last : 'msg stream -> 'msg stream 
  = "last"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external end_when : 'any stream -> 'msg stream -> 'msg stream = "endWhen"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external combine : 'msg stream -> 'msg stream -> ('msg * 'msg) stream
  = "combine"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external combine3 :
  'msg stream -> 'msg stream -> 'msg stream -> ('msg * 'msg * 'msg) stream
  = "combine"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external combine4 :
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  ('msg * 'msg * 'msg * 'msg) stream = "combine"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external combine5 :
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  ('msg * 'msg * 'msg * 'msg * 'msg) stream = "combine"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external combine6 :
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  ('msg * 'msg * 'msg * 'msg * 'msg * 'msg) stream = "combine"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external merge : 'msg stream -> 'msg stream -> 'msg stream = "merge"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external merge3 : 'msg stream -> 'msg stream -> 'msg stream -> 'msg stream
  = "merge"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external merge4 :
  'msg stream -> 'msg stream -> 'msg stream -> 'msg stream -> 'msg stream
  = "merge"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external merge5 :
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream = "merge"
  [@@bs.module "xstream"] [@@bs.scope "default"]

external merge6 :
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream ->
  'msg stream = "merge"
  [@@bs.module "xstream"] [@@bs.scope "default"]

type 'b _operator

external _sample_combine : 'a stream -> 'b _operator = "default"
  [@@bs.module "xstream/extra/sampleCombine"]

external _compose : 'a stream -> 'b _operator -> 'b stream = "compose"
  [@@bs.send]

let with_latest_on (trigger : 'b stream) (latest_stream : 'a stream) :
    ('b * 'a) stream =
  _sample_combine latest_stream |> _compose trigger
