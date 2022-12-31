include Date_time

let of_string s =
  let lexbuf = Lexing.from_string s in
  Parser.imf_fixdate Lexer.token lexbuf
