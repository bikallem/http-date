type t
type day_name = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]

type month =
  [ `Jan
  | `Feb
  | `Mar
  | `Apr
  | `May
  | `Jun
  | `Jul
  | `Aug
  | `Sep
  | `Oct
  | `Nov
  | `Dec ]

type encode_fmt = [ `IMF_fixdate | `RFC850_date | `ASCTIME_date ]

val create :
  day_name:day_name ->
  day:int ->
  month:month ->
  year:int ->
  hour:int ->
  minute:int ->
  second:int ->
  t

val decode : string -> t
val encode : ?encode_fmt:encode_fmt -> t -> string

(** {2 Retrieve date time details} *)

val day_name : t -> day_name
val day : t -> int
val month : t -> month
val year : t -> int
val hour : t -> int
val minute : t -> int
val second : t -> int
val pp : ?encode_fmt:encode_fmt -> Format.formatter -> t -> unit
