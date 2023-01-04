%{
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
      (`ASCTIME, (year, month, day), (time, 0))
    }

date1 : day=DIGIT2 SP   month=MONTH SP   year=DIGIT4 { (year, month, day) }
date2 : day=DIGIT2 DASH month=MONTH DASH year=DIGIT2 { (year, month, day) }
date3 :
  | month=MONTH SP SP day=DIGIT  { (month, day) }
  | month=MONTH SP    day=DIGIT2 { (month, day) }

time_of_day : hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2 { (hour, minute, second) }
