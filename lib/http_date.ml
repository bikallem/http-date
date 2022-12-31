module Day_name = Day_name
module Month = Month
module Day = Day

let parse s =
  let lexbuf = Lexing.from_string s in
  Parser.imf_fixdate Lexer.token lexbuf
