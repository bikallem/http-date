(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)
type decoder = { buf : string; mutable pos : int }

type t = [ `IMF of datetime | `RFC850 of datetime | `ASCTIME of datetime ]
and date = int * int * int (* year, month, day *)
and time = int * int * int (* hour, minute, second *)
and dayname = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]
and datetime = dayname * date * time

let[@inline always] advance d n : unit = d.pos <- d.pos + n

let expect d c : unit =
  let c1 = d.buf.[d.pos] in
  if c = c1 then advance d 1
  else Printf.sprintf "Expected %C but got %C" c c1 |> invalid_arg

let[@inline always] space d : unit = expect d ' '
let[@inline always] comma d : unit = expect d ','
let[@inline always] colon d : unit = expect d ':'

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

let is_alpha_num = function
  | '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' -> true
  | _ -> false

let string d : string =
  let buf = Buffer.create 5 in
  while is_alpha_num d.buf.[d.pos] && d.pos < String.length d.buf do
    Buffer.add_char buf d.buf.[d.pos];
    advance d 1
  done;
  Buffer.contents buf

type dayname_tok = Short of dayname | Long of dayname
(* dayname token *)

let dayname_tok d : dayname_tok =
  let s = string d in
  match s with
  | "Mon" -> Short `Mon
  | "Tue" -> Short `Tue
  | "Wed" -> Short `Wed
  | "Thu" -> Short `Thu
  | "Fri" -> Short `Fri
  | "Sat" -> Short `Sat
  | "Sun" -> Short `Sun
  | "Monday" -> Long `Mon
  | "Tuesday" -> Long `Tue
  | "Wednesday" -> Long `Wed
  | "Thursday" -> Long `Thu
  | "Friday" -> Long `Fri
  | "Saturday" -> Long `Sat
  | "Sunday" -> Long `Sun
  | s -> invalid_arg @@ "Invalid dayname value '" ^ s ^ "'"

type punctuation_token = Comma | Space

let punctuation_token d : punctuation_token =
  let tok =
    match d.buf.[d.pos] with
    | ' ' -> Space
    | ',' -> Comma
    | c -> Printf.sprintf "Invalid punctuation token '%C'" c |> invalid_arg
  in
  advance d 1;
  tok

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

(* -- IMF datetime -- *)
let imf_date d : date * time =
  space d;
  let date1 = date1 d in
  space d;
  let time_of_day = time_of_day d in
  space d;
  gmt d;
  (date1, time_of_day)

(* -- RFC850 datetime -- *)

let date2 d : date =
  let dd = day d in
  expect d '-';
  let m = month d in
  expect d '-';
  let y = digits d 2 in
  (y, m, dd)

let rfc850_date d : date * time =
  comma d;
  space d;
  let date2 = date2 d in
  space d;
  let time = time_of_day d in
  space d;
  gmt d;
  (date2, time)

(* asctime datetime *)
let date3 d : int * int =
  (* month, day *)
  let m = month d in
  space d;
  let dd =
    match d.buf.[d.pos] with
    | ' ' ->
        space d;
        digits d 1
    | _ -> digits d 2
  in
  (m, dd)

let asctime_date d : date * time =
  let m, dd = date3 d in
  space d;
  let time = time_of_day d in
  space d;
  let y = year d in
  ((y, m, dd), time)

let decode s : t =
  let d = { buf = s; pos = 0 } in
  match dayname_tok d with
  | Long dayname ->
      let date, time = rfc850_date d in
      `RFC850 (dayname, date, time)
  | Short dayname ->
      begin match punctuation_token d with
      | Comma ->
          let d, t = imf_date d in
          `IMF (dayname, d, t)
      | Space ->
          let d, t = asctime_date d in
          `ASCTIME (dayname, d, t)
      end

let pp fmt t : unit =
  let dayname_long = function
    | `Mon -> "Monday"
    | `Tue -> "Tuesday"
    | `Wed -> "Wednesday"
    | `Thu -> "Thursday"
    | `Fri -> "Friday"
    | `Sat -> "Saturday"
    | `Sun -> "Sunday"
  in
  let dayname_short = function
    | `Mon -> "Mon"
    | `Tue -> "Tue"
    | `Wed -> "Wed"
    | `Thu -> "Thu"
    | `Fri -> "Fri"
    | `Sat -> "Sat"
    | `Sun -> "Sun"
  in
  let month_string mm =
    match mm with
    | 1 -> "Jan"
    | 2 -> "Feb"
    | 3 -> "Mar"
    | 4 -> "Apr"
    | 5 -> "May"
    | 6 -> "Jun"
    | 7 -> "Jul"
    | 8 -> "Aug"
    | 9 -> "Sep"
    | 10 -> "Oct"
    | 11 -> "Nov"
    | 12 -> "Dec"
    | _ -> assert false
  in
  match t with
  | `IMF (dayname, (y, m, d), (hh, mm, ss)) ->
      Format.fprintf fmt "%s, %02d %s %04d %02d:%02d:%02d GMT"
        (dayname_short dayname) d (month_string m) y hh mm ss
  | `RFC850 (dayname, (y, m, d), (hh, mm, ss)) ->
      Format.fprintf fmt "%s, %02d-%s-%02i %02d:%02d:%02d GMT"
        (dayname_long dayname) d (month_string m) y hh mm ss
  | `ASCTIME (dayname, (y, m, d), (hh, mm, ss)) ->
      Format.fprintf fmt "%s %s %2d %02d:%02d:%02d %04d" (dayname_short dayname)
        (month_string m) d hh mm ss y

let encode t : string =
  pp Format.str_formatter t;
  Format.flush_str_formatter ()
