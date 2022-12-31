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

val of_string : string -> t
val pp : Format.formatter -> t -> unit
