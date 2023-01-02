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
  | d=imf_fixdate  { d }
  | d=rfc850_date  { d }
  | d=asctime_date { d }

imf_fixdate : day_name=DAY_NAME COMMA SP date=date1 SP time=time_of_day SP GMT
  { Date_time.create day_name date time }

date1 : day=DIGIT2 SP month=MONTH SP year=DIGIT4 { (day, month, year) }

time_of_day : hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2 { (hour, minute, second) }

rfc850_date : day_name=DAY_NAME_L COMMA SP date=date2 SP time=time_of_day SP GMT
  { Date_time.create day_name date time }

date2 : day=DIGIT2 DASH month=MONTH DASH year=DIGIT2 { (day, month, year) }

asctime_date : day_name=DAY_NAME SP date=date3 SP time=time_of_day SP year=DIGIT4
  {
    let (month, day) = date in
    Date_time.create day_name (day, month, year) time
  }

date3 :
  | month=MONTH SP SP day=DIGIT  { (month, day) }
  | month=MONTH SP    day=DIGIT2 { (month, day) }
