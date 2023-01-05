{
(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)

  open Parser
}

let digit = ['0'-'9'] as num
let digit_2 = (digit digit) as num
let digit_4 = (digit digit digit digit) as num
let day_name = ("Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun")
let day_name_l = ("Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday" | "Saturday" | "Sunday")
let gmt = "GMT"

rule token = parse
| day_name   { DAY_NAME }
| day_name_l { DAY_NAME_L }
| "Jan"      { MONTH 1 }
| "Feb"      { MONTH 2 }
| "Mar"      { MONTH 3 }
| "Apr"      { MONTH 4 }
| "May"      { MONTH 5 }
| "Jun"      { MONTH 6 }
| "Jul"      { MONTH 7 }
| "Aug"      { MONTH 8 }
| "Sep"      { MONTH 9 }
| "Oct"      { MONTH 10 }
| "Nov"      { MONTH 11 }
| "Dec"      { MONTH 12 }
| digit_2    { DIGIT2 (int_of_string num) }
| digit_4    { DIGIT4 (int_of_string num) }
| digit      { DIGIT (int_of_string @@ Char.escaped num) }
| ','        { COMMA }
| ':'        { COLON }
| '-'        { DASH }
| gmt        { GMT }
| ' '        { SP }
| eof        { EOF }
| _ as c     { raise @@ Invalid_argument (Printf.sprintf "Unrecognized character '%c' at position %d" c (Lexing.lexeme_end lexbuf)) }
