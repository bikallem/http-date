(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)

type encoding = IMF | RFC850 | ASCTIME

let day_name_string ?(short_label = true) ptime =
  match Ptime.weekday ptime with
  | `Mon -> if short_label then "Mon" else "Monday"
  | `Tue -> if short_label then "Tue" else "Tuesday"
  | `Wed -> if short_label then "Wed" else "Wednesday"
  | `Thu -> if short_label then "Thu" else "Thursday"
  | `Fri -> if short_label then "Fri" else "Friday"
  | `Sat -> if short_label then "Sat" else "Saturday"
  | `Sun -> if short_label then "Sun" else "Sunday"

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

let pp ?(encoding = IMF) fmt ptime =
  let (year, month, day), ((hour, minute, second), _) =
    Ptime.to_date_time ptime
  in
  match encoding with
  | IMF ->
      Format.fprintf fmt "%s, %02d %s %04d %02d:%02d:%02d GMT%!"
        (day_name_string ptime) day (month_string month) year hour minute second
  | RFC850 ->
      let year =
        let s = Int.to_string year in
        let len = String.length s in
        let s = if len > 2 then String.sub s (len - 2) 2 else s in
        int_of_string s
      in
      Format.fprintf fmt "%s, %02d-%s-%02i %02d:%02d:%02d GMT%!"
        (day_name_string ~short_label:false ptime)
        day (month_string month) year hour minute second
  | ASCTIME ->
      Format.fprintf fmt "%s %s %2d %02d:%02d:%02d %04d%!"
        (day_name_string ptime) (month_string month) day hour minute second year

let decode ?century s =
  try
    let lexbuf = Lexing.from_string s in
    let encoding, date, time = Parser.http_date Lexer.token lexbuf in
    match encoding with
    | `IMF -> Ptime.of_date_time (date, time) |> Option.get
    | `RFC850 ->
        let y, m, d = date in
        let y =
          match century with Some century -> (century * 100) + y | None -> y
        in
        Ptime.of_date_time ((y, m, d), time) |> Option.get
    | `ASCTIME -> Ptime.of_date_time (date, time) |> Option.get
  with exn -> failwith @@ Printexc.to_string exn

let encode ?(encoding = IMF) t =
  let buf = Buffer.create 29 in
  let fmt = Format.formatter_of_buffer buf in
  pp ~encoding fmt t;
  Buffer.contents buf
