include Date_time

let decode s =
  let lexbuf = Lexing.from_string s in
  Parser.imf_fixdate Lexer.token lexbuf

let encode t =
  let buf = Buffer.create 29 in
  let fmt = Format.formatter_of_buffer buf in
  pp fmt t;
  Buffer.contents buf
