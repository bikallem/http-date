type decoder = { buf : string; mutable pos : int }

type t = date * time
and date = int * int * int (* year, month, day *)
and time = int * int * int (* hour, minute, second *)

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

type day_token = Short | Long

let day_name_token d : day_token =
  let s = string d in
  match s with
  | "Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun" -> Short
  | "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday" | "Saturday"
  | "Sunday" ->
      Long
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

let decode s : date * time =
  let d = { buf = s; pos = 0 } in
  match day_name_token d with
  | Long -> rfc850_date d
  | Short ->
      begin match punctuation_token d with
      | Comma -> imf_date d
      | Space -> asctime_date d
      end
