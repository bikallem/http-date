{
  open Parser
}

let digit = ['0'-'9'] as num
let digit_2 = (digit digit) as num
let digit_4 = (digit digit digit digit) as num
let day_name = ("Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun") as day_name
let day_name_l = ("Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday" | "Saturday" | "Sunday") as day_name_l
let month = ("Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" | "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec") as month
let gmt = "GMT"

rule token = parse
| day_name   { DAY_NAME (Date_time.day_name_of_string day_name) }
| day_name_l { DAY_NAME_L (Date_time.day_name_of_string_long day_name_l) }
| month      { MONTH (Date_time.month_of_string month) }
| digit_2    { DIGIT2 (int_of_string num) }
| digit_4    { DIGIT4 (int_of_string num) }
| digit      { DIGIT (Printf.sprintf "%c" num |> int_of_string) }
| ','        { COMMA }
| ':'        { COLON }
| '-'        { DASH }
| gmt        { GMT }
| ' '        { SP }
| eof        { EOF }
| _ as c     { failwith @@ Printf.sprintf "Unrecognized character '%c'" c }
