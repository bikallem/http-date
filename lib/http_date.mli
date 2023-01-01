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

type day = int
type t
type encode_fmt = [ `IMF_fixdate | `RFC850_datek | `ASCTIME_date ]

val decode : string -> t
val encode : ?encode_fmt:encode_fmt -> t -> string
val pp : ?encode_fmt:encode_fmt -> Format.formatter -> t -> unit
