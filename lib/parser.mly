%{
%}

%token <Day_name.t> DAY_NAME
%token <Day_name.t> DAY_NAME_L
%token <Month.t> MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token COMMA
%token COLON
%token GMT
%token SP
%token EOF

%start <Date_time.t> imf_fixdate

%%

imf_fixdate: day_name=DAY_NAME COMMA SP date = date1 SP time = time_of_day SP GMT
  { Date_time.imf_fixdate day_name date time }

date1 : day=DIGIT2 SP month=MONTH SP year=DIGIT4
  {
    let day = Day.of_int day in
    (day, month, year)
  }

time_of_day :
  | hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2
    { Date_time.parse_time (hour, minute, second) }
