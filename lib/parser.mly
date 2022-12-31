%{
%}

%token <Date.Day_name.t> DAY_NAME
%token <Date.Day_name.t> DAY_NAME_L
%token <Date.Month.t> MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token COMMA
%token COLON
%token GMT
%token SP
%token EOF

%start <Date.Day_name.t> imf_fixdate

%%

imf_fixdate: day_name=DAY_NAME COMMA SP date1 SP time_of_day SP GMT { day_name }

date1 : day=DIGIT2 SP month=MONTH SP year=DIGIT4 { (day, month, year) }

time_of_day : hour=DIGIT2 COLON minute=DIGIT2 COLON second=DIGIT2 { (hour, minute, second) }
