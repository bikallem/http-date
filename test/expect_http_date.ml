let show t = Format.printf "%a@." Http_date.pp t

let%expect_test "IMF fixdate" =
  let t = Http_date.decode "Sun, 06 Nov 1994 08:49:37 GMT" in
  show t;
  print_endline (Http_date.encode t);
  [%expect
    {|
    Sun, 06 Nov 1994 08:49:37 GMT
    Sun, 06 Nov 1994 08:49:37 GMT
    |}]

let%expect_test "RFC 850 date" =
  let t = Http_date.decode "Sunday, 06-Nov-94 08:49:37 GMT" in
  show t;
  print_endline (Http_date.encode t);
  [%expect
    {|
    Sunday, 06-Nov-94 08:49:37 GMT
    Sunday, 06-Nov-94 08:49:37 GMT
    |}]

let%expect_test "asctime date" =
  let t = Http_date.decode "Sun Nov  6 08:49:37 1994" in
  show t;
  print_endline (Http_date.encode t);
  [%expect {|
    Sun Nov  6 08:49:37 1994
    Sun Nov  6 08:49:37 1994
    |}]

let%expect_test "decode reports the parsed format and fields" =
  let open Http_date in
  (match decode "Sun, 06 Nov 1994 08:49:37 GMT" with
  | `IMF ((`Sun : dayname), (y, m, d), (hh, mm, ss)) ->
      Printf.printf "IMF %d-%d-%d %d:%d:%d\n" y m d hh mm ss
  | _ -> print_endline "unexpected format");
  [%expect {| IMF 1994-11-6 8:49:37 |}]

let%expect_test "malformed input raises Invalid_argument" =
  List.iter
    (fun s ->
      match Http_date.decode s with
      | _ -> Printf.printf "%S: decoded\n" s
      | exception Invalid_argument _ -> Printf.printf "%S: invalid\n" s)
    [ ""; "Sun, 06 Nov 1994 08:49:37 PST"; "Sun, 6 Nov 1994 08:49:37 GMT" ];
  [%expect
    {|
    "": invalid
    "Sun, 06 Nov 1994 08:49:37 PST": invalid
    "Sun, 6 Nov 1994 08:49:37 GMT": invalid
    |}]
