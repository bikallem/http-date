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

type t = {
  day_name : day_name;
  day : int;
  month : month;
  year : int;
  hour : int;
  minute : int;
  second : int;
}

let parse_time (hh, mm, ss) =
  let hh =
    if hh >= 0 && hh <= 23 then hh
    else raise @@ Invalid_argument "hour must be >=0 and <= 23"
  in
  let mm =
    if mm >= 0 && mm <= 59 then mm
    else raise @@ Invalid_argument "minute must be >=0 and <= 59"
  in
  let ss =
    if ss >= 0 && ss <= 60 then ss
    else raise @@ Invalid_argument "second must be btween >=0 and <=60"
  in
  (hh, mm, ss)

let day_of_int day =
  if day >= 1 && day <= 31 then day
  else raise (Invalid_argument "day must be >= 1 and <= 31")

let year_of_int year =
  if year >= 1 && year <= 9999 then year
  else raise @@ Invalid_argument "year must be >=1 and <= 9999"

let create ~day_name ~day ~month ~year ~hour ~minute ~second =
  let hour, minute, second = parse_time (hour, minute, second) in
  let day = day_of_int day in
  let year = year_of_int year in
  { day_name; day; month; year; hour; minute; second }

let day_name t = t.day_name
let day t = t.day
let month t = t.month
let year t = t.year
let hour t = t.hour
let minute t = t.minute
let second t = t.second

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

type encode_fmt = [ `IMF_fixdate | `RFC850_date | `ASCTIME_date ]

let pp ?(encode_fmt = `IMF_fixdate) fmt
    { day_name; day; month; year; hour; minute; second } =
  match encode_fmt with
  | `IMF_fixdate ->
      Format.fprintf fmt "%s, %02d %s %04d %02d:%02d:%02d GMT%!"
        (day_name_to_string day_name)
        day (month_to_string month) year hour minute second
  | `RFC850_date ->
      Format.fprintf fmt "%s, %02d-%s-%02d %02d:%02d:%02d GMT%!"
        (day_name_to_string_l day_name)
        day (month_to_string month) year hour minute second
  | `ASCTIME_date ->
      Format.fprintf fmt "%s %s %2d %02d:%02d:%02d %04d%!"
        (day_name_to_string day_name)
        (month_to_string month) day hour minute second year
