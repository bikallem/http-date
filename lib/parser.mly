%{
(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)

(* validate_* () functions below are based on code from
https://github.com/dbuenzli/ptime/blob/master/src/ptime.ml.
It has the following copyright:
  
  Copyright (c) 2015 The ptime programmers. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file. 
*)

let max_month_day =               (* max day number in a given year's month. *)
  let is_leap_year y = (y mod 4 = 0) && (y mod 100 <> 0 || y mod 400 = 0) in
  let mlen = [|31; 28 (* or not *); 31; 30; 31; 30; 31; 31; 30; 31; 30; 31|] in
  fun y m -> if (m = 2 && is_leap_year y) then 29 else mlen.(m - 1)

let validate_date (y, m, d) =
  if (0 <= y && y <= 9999 && 1 <= m && m <= 12 && 1 <= d && d <= max_month_day y m)
  then (y, m, d)
  else raise @@ Invalid_argument (Printf.sprintf "date - (y,m,d) - value '(%d, %d, %d)' is invalid" y m d)

let validate_time (hh, mm, ss) =
  if (0 <= hh && hh <= 23 && 0 <= mm && mm <= 59 && 0 <= ss && ss <= 60)
  then (hh, mm, ss)
  else raise @@ Invalid_argument (Printf.sprintf "time - (h,m,s) - value '(%d, %d, %d)' is invalid" hh mm ss) 
%}

%token DAY_NAME
%token DAY_NAME_L
%token <int>MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token <int>DIGIT
%token COMMA
%token COLON
%token DASH
%token GMT
%token SP
%token EOF

%start <[`IMF | `RFC850 | `ASCTIME ] * Ptime.date * Ptime.time> http_date

%%

http_date :
  | DAY_NAME   COMMA SP date=date1 SP time=time_of_day SP GMT { (`IMF, date, (time,0)) }
  | DAY_NAME_L COMMA SP date=date2 SP time=time_of_day SP GMT { (`RFC850, date, (time,0)) }
  | DAY_NAME         SP date=date3 SP time=time_of_day SP year=DIGIT4
    {
      let (month, day) = date in
      let (year, month, day) = validate_date (year, month, day) in
      (`ASCTIME, (year, month, day), (time, 0))
    }

date1 : day=DIGIT2 SP   month=MONTH SP   year=DIGIT4 { validate_date (year, month, day) }
date2 : day=DIGIT2 DASH month=MONTH DASH year=DIGIT2 { validate_date (year, month, day) }
date3 :
  | month=MONTH SP SP day=DIGIT  { (month, day) }
  | month=MONTH SP    day=DIGIT2 { (month, day) }

time_of_day : hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2 { validate_time (hour, minute, second) }
