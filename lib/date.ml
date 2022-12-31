module Day_name = struct
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
end

module Month = struct
  type t =
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

  let to_string t =
    match t with
    | `Jan -> "Jan"
    | `Feb -> "Feb"
    | `Mar -> "Mar"
    | `Apr -> "Apr"
    | `May -> "May"
    | `Jun -> "Jun"
    | `Jul -> "Jul"
    | `Aug -> "Aug"
    | `Sep -> "Sep"
    | `Oct -> "Oct"
    | `Nov -> "Nov"
    | `Dec -> "Dec"

  let of_string s =
    match s with
    | "Jan" -> `Jan
    | "Feb" -> `Feb
    | "Mar" -> `Mar
    | "Apr" -> `Apr
    | "May" -> `May
    | "Jun" -> `Jun
    | "Jul" -> `Jul
    | "Aug" -> `Aug
    | "Sep" -> `Sep
    | "Oct" -> `Oct
    | "Nov" -> `Nov
    | "Dec" -> `Dec
    | _ -> raise @@ Invalid_argument s
end

module Day = struct
  type t = int

  let of_int day =
    if day >= 1 && day <= 31 then day
    else
      raise
        (Invalid_argument
           ("Day - " ^ string_of_int day ^ ". Day must be >= 1 and <= 31"))

  let of_string s = of_int (int_of_string s)
  let to_string t = string_of_int t

  external to_int : t -> int = "%identity"
end
