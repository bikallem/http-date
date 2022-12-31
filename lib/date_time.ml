type year = int
type hour = int
type minute = int
type second = int

type t =
  | Imf_fixdate of Day_name.t * Day.t * Month.t * year * hour * minute * second
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
