{
  open Parser
  open Date
}

let digit = ['0'-'9']
let digit_2 = (digit digit) as num
let digit_4 = (digit digit digit digit) as num
let day_name = ("Mon" | "Tue" | "Wed" | "Thu" | "Fri" | "Sat" | "Sun") as day_name
let day_name_l = ("Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday" | "Saturday" | "Sunday") as day_name_l
let month = ("Jan" | "Feb" | "Mar" | "Apr" | "May" | "Jun" | "Jul" | "Aug" | "Sep" | "Oct" | "Nov" | "Dec") as month
let gmt = "GMT"

rule token = parse
| day_name   { DAY_NAME (Day_name.of_string day_name) }
| day_name_l { DAY_NAME_L (Day_name.of_string day_name_l) } 
| month      { MONTH (Month.of_string month) }
| digit_2    { DIGIT2 (int_of_string num) }
| digit_4    { DIGIT4 (int_of_string num) }
| ','        { COMMA }
| ':'        { COLON }
| gmt        { GMT }
| ' '        { SP }
| eof        { EOF }
| _ as c     { failwith @@ Printf.sprintf "Unrecognized character '%c'" c }
