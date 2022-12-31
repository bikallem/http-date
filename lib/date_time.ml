type year = int
type hour = int
type minute = int
type second = int
type day_name = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]
type day = int

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

type t =
  | Imf_fixdate of day_name * day * month * year * hour * minute * second
  | Rfc850_date
  | Asctime_date

let imf_fixdate dayname (day, month, year) (h, m, s) =
  Imf_fixdate (dayname, day, month, year, h, m, s)

let parse_time (hh, mm, ss) =
  let hh =
    if hh >= 0 && hh <= 23 then hh
    else raise @@ Invalid_argument (Printf.sprintf "hour %d" hh)
  in
  let mm =
    if mm >= 0 && mm <= 59 then mm
    else raise @@ Invalid_argument (Printf.sprintf "minute %d" mm)
  in
  let ss =
    if ss >= 0 && ss <= 60 then ss
    else raise @@ Invalid_argument (Printf.sprintf "second %d" ss)
  in
  (hh, mm, ss)

let day_of_int day =
  if day >= 1 && day <= 31 then day
  else
    raise
      (Invalid_argument
         ("Day - " ^ string_of_int day ^ ". Day must be >= 1 and <= 31"))

let day_name_to_string t =
  match t with
  | `Mon -> "Mon"
  | `Tue -> "Tue"
  | `Wed -> "Wed"
  | `Thu -> "Thu"
  | `Fri -> "Fri"
  | `Sat -> "Sat"
  | `Sun -> "Sun"

let day_name_to_string_l t =
  match t with
  | `Mon -> "Monday"
  | `Tue -> "Tueday"
  | `Wed -> "Wedday"
  | `Thu -> "Thuday"
  | `Fri -> "Friday"
  | `Sat -> "Satday"
  | `Sun -> "Sunday"

let day_name_of_string s =
  match s with
  | "Mon" -> `Mon
  | "Tue" -> `Tue
  | "Wed" -> `Wed
  | "Thu" -> `Thu
  | "Fri" -> `Fri
  | "Sat" -> `Sat
  | "Sun" -> `Sun
  | s -> raise @@ Invalid_argument s

let day_name_of_string_long s =
  match s with
  | "Monday" -> `Mon
  | "Tueday" -> `Tue
  | "Wedday" -> `Wed
  | "Thuday" -> `Thu
  | "Friday" -> `Fri
  | "Satday" -> `Sat
  | "Sunday" -> `Sun
  | s -> raise @@ Invalid_argument s

let month_to_string t =
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

let month_of_string s =
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

let pp fmt = function
  | Imf_fixdate (day_name, day, month, year, hour, minutes, seconds) ->
      Format.fprintf fmt "%s, %02d %s %04d %02d:%02d:%02d GMT"
        (day_name_to_string day_name)
        day (month_to_string month) year hour minutes seconds
  | _ -> assert false
