%{
%}

%token <Date.Day_name.t> DAY_NAME
%token <Date.Day_name.t> DAY_NAME_L
%token <Date.Month.t> MONTH
%token <int>DIGIT2
%token <int>DIGIT4
%token COMMA
%token GMT
%token SP
%token EOF

%start <Date.Day_name.t> imf_fixdate

%%

imf_fixdate: day_name=DAY_NAME COMMA SP { day_name }

/* date1 : day=DIGIT2 SP month=MONTH SP year=DIGIT4 { () } */
