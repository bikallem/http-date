type t = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]

let to_string t =
  match t with
  | `Mon -> "Mon"
  | `Tue -> "Tue"
  | `Wed -> "Wed"
  | `Thu -> "Thu"
  | `Fri -> "Fri"
  | `Sat -> "Sat"
  | `Sun -> "Sun"

let of_string s =
  match s with
  | "Mon" -> `Mon
  | "Tue" -> `Tue
  | "Wed" -> `Wed
  | "Thu" -> `Thu
  | "Fri" -> `Fri
  | "Sat" -> `Sat
  | "Sun" -> `Sun
  | s -> raise @@ Invalid_argument s

let of_string_long s =
  match s with
  | "Monday" -> `Mon
  | "Tueday" -> `Tue
  | "Wedday" -> `Wed
  | "Thuday" -> `Thu
  | "Friday" -> `Fri
  | "Satday" -> `Sat
  | "Sunday" -> `Sun
  | s -> raise @@ Invalid_argument s
