include Date

let parse s =
  let lexbuf = Lexing.from_string s in
  Parser.imf_fixdate Lexer.token lexbuf
