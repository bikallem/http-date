%{
%}

%token <Date_time.day_name> DAY_NAME
%token <Date_time.day_name> DAY_NAME_L
%token <Date_time.month> MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token <int>DIGIT
%token COMMA
%token COLON
%token DASH
%token GMT
%token SP
%token EOF

%start <Date_time.t> http_date

%%

http_date :
  | day_name=DAY_NAME COMMA SP date=date1 SP f=time_of_day SP GMT (* IMF fixdate *)
  | day_name=DAY_NAME_L COMMA SP date=date2 SP f=time_of_day SP GMT (* RFC850 date *)
    {
      let (day, month, year) = date in
      f ~day_name ~day ~month ~year
    }
  | day_name=DAY_NAME SP date=date3 SP f=time_of_day SP year=DIGIT4 (* ASCTIME date *)
    {
      let (month, day) = date in
      f ~day_name ~day ~month ~year
    }

date1 : day=DIGIT2 SP   month=MONTH SP   year=DIGIT4 { (day, month, year) }
date2 : day=DIGIT2 DASH month=MONTH DASH year=DIGIT2 { (day, month, year) }
date3 :
  | month=MONTH SP SP day=DIGIT  { (month, day) }
  | month=MONTH SP    day=DIGIT2 { (month, day) }

time_of_day : hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2
  { Date_time.create ~hour ~minute ~second }
