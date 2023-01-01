include Date_time

let decode s =
  let lexbuf = Lexing.from_string s in
  Parser.http_date Lexer.token lexbuf

let encode ?(encode_fmt = `IMF_fixdate) t =
  let buf = Buffer.create 29 in
  let fmt = Format.formatter_of_buffer buf in
  pp ~encode_fmt fmt t;
  Buffer.contents buf
