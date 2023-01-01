%{
%}

%token <Date_time.day_name> DAY_NAME
%token <Date_time.day_name> DAY_NAME_L
%token <Date_time.month> MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token COMMA
%token COLON
%token DASH
%token GMT
%token SP
%token EOF

%start <Date_time.t> http_date

%%

http_date :
  | d=imf_fixdate { d }
  | d=rfc850_date { d }

imf_fixdate : day_name=DAY_NAME COMMA SP date=date1 SP time=time_of_day SP GMT
  { Date_time.create day_name date time }

date1 : day=DIGIT2 SP month=MONTH SP year=DIGIT4
  {
    let day = Date_time.day_of_int day in
    (day, month, year)
  }

time_of_day :
  | hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2
    { Date_time.parse_time (hour, minute, second) }

rfc850_date : day_name=DAY_NAME_L COMMA SP date=date2 SP time=time_of_day SP GMT
  { Date_time.create day_name date time }

date2 : day=DIGIT2 DASH month=MONTH DASH year=DIGIT2
  {
    let day = Date_time.day_of_int day in
    (day, month, year)
  }
