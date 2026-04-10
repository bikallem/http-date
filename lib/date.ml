type decoder = { buf : string; mutable pos : int }
type date = int * int * int (* year, month, day *)
type time = int * int * int (* hour, minute, second *)

let advance d n : unit = d.pos <- d.pos + n

let expect d c : unit =
  let c1 = d.buf.[d.pos] in
  if c = c1 then advance d 1
  else Printf.sprintf "Expected %C but got %C" c c1 |> invalid_arg

let day_name_short d : unit =
  let day = String.sub d.buf d.pos 3 in
  match day with
  | "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun" -> advance d 3
  | _ -> Printf.sprintf "Invalid day value '%s'" day |> invalid_arg

let space d : unit = expect d ' '
let comma d : unit = expect d ','
let colon d : unit = expect d ':'

let month d : int =
  let m = String.sub d.buf d.pos 3 in
  let m =
    match m with
    | "Jan" -> 1
    | "Feb" -> 2
    | "Mar" -> 3
    | "Apr" -> 4
    | "May" -> 5
    | "Jun" -> 6
    | "Jul" -> 7
    | "Aug" -> 8
    | "Sep" -> 9
    | "Oct" -> 10
    | "Nov" -> 11
    | "Dec" -> 12
    | _ -> Printf.sprintf "Invalid month value '%s'" m |> invalid_arg
  in
  advance d 3;
  m

let digits d (n : int) : int =
  for i = 0 to n - 1 do
    match d.buf.[d.pos + i] with
    | '0' .. '9' -> ()
    | c -> Printf.sprintf "expected digit but got %C" c |> invalid_arg
  done;
  let digit_chars = String.sub d.buf d.pos n in
  advance d n;
  int_of_string digit_chars

let year d : int = digits d 4
let day d = digits d 2

let date1 d : date =
  let dd = day d in
  space d;
  let m = month d in
  space d;
  let y = year d in
  (y, m, dd)

let time_of_day d : time =
  let hour = digits d 2 in
  colon d;
  let minute = digits d 2 in
  colon d;
  let second = digits d 2 in
  (hour, minute, second)

let gmt d : unit =
  let txt = [| 'G'; 'M'; 'T' |] in
  for i = 0 to 2 do
    let c = d.buf.[d.pos + i] in
    if c != txt.(i) then
      Printf.sprintf "expected '%C' but got '%C'" txt.(i) c |> invalid_arg
  done

let imf_date d : date * time =
  day_name_short d;
  comma d;
  space d;
  let date1 = date1 d in
  space d;
  let time_of_day = time_of_day d in
  space d;
  gmt d;
  (date1, time_of_day)

let max_month_day y m =
  let is_leap_year y = y mod 4 = 0 && (y mod 100 <> 0 || y mod 400 = 0) in
  let mlen =
    [| 31; 28 (* or not *); 31; 30; 31; 30; 31; 31; 30; 31; 30; 31 |]
  in
  if m = 2 && is_leap_year y then 29 else mlen.(m - 1)

let is_valid_date_time ((y, m, d), (hh, mm, ss)) : bool =
  let valid_date =
    0 <= y && y <= 9999 && 1 <= m && m <= 12 && 1 <= d && d <= max_month_day y m
  in
  let valid_time =
    0 <= hh && hh <= 23 && 0 <= mm && hh <= 59 && 0 <= ss && ss <= 60
  in
  valid_date && valid_time

let decode s : Ptime.t =
  let d = { buf = s; pos = 0 } in
  let date, time = imf_date d in
  if not (is_valid_date_time (date, time)) then
    invalid_arg "Invalid date time value"
  else
    (* timezone offset is 0 for GMT. GMT is the HTTP specified timezone. *)
    let tz_offset = 0 in
    Ptime.of_date_time (date, (time, tz_offset)) |> Option.get
