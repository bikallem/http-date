open Windtrap

(* -- Witness and generators for Http_date.t -- *)

let http_date : Http_date.t testable =
  Testable.make ~pp:Http_date.pp ~equal:( = )

(* `dayname` is independent of `(y,m,d)`: the codec preserves whatever weekday
   the input carries without cross-checking. Round-trip still holds. *)
let dayname : Http_date.dayname Gen.t =
  Gen.of_list [ `Mon; `Tue; `Wed; `Thu; `Fri; `Sat; `Sun ]

let month = Gen.int_range 1 12

(* `day` capped at 28: the parser doesn't validate day-of-month vs month, but 28
   is safe for all months so round-trips never depend on calendar logic. *)
let day = Gen.int_range 1 28

let time : Http_date.time Gen.t =
  Gen.triple (Gen.int_range 0 23) (Gen.int_range 0 59) (Gen.int_range 0 59)

let date ~years : Http_date.date Gen.t =
  Gen.triple (Gen.int_range 0 (years - 1)) month day

(* RFC 850 uses a 2-digit year (0-99): anything >= 100 would break the
   round-trip. *)
let imf_t =
  Gen.map
    (fun (n, d, t) -> `IMF (n, d, t))
    (Gen.triple dayname (date ~years:10_000) time)

let rfc850_t =
  Gen.map
    (fun (n, d, t) -> `RFC850 (n, d, t))
    (Gen.triple dayname (date ~years:100) time)

let asctime_t =
  Gen.map
    (fun (n, d, t) -> `ASCTIME (n, d, t))
    (Gen.triple dayname (date ~years:10_000) time)

(* Random strings almost never parse, so also draw a valid encoding and either
   keep it, swap one byte for a digit, letter or space (which often still
   parses), or cut it short. *)
let near_miss : string Gen.t =
  let open Gen in
  let* t = one_of [ imf_t; rfc850_t; asctime_t ] in
  let s = Http_date.encode t in
  let* i = int_range 0 (String.length s - 1) in
  let alnum =
    one_of
      [
        char_range '0' '9'; char_range 'a' 'z'; char_range 'A' 'Z'; constant ' ';
      ]
  in
  one_of
    [
      constant s;
      map (fun c -> String.mapi (fun j c' -> if i = j then c else c') s) alnum;
      constant (String.sub s 0 i);
    ]

let round_trip t = equal http_date t (Http_date.decode (Http_date.encode t))

(* -- Properties -- *)

let properties =
  group "properties"
    [
      (* decode must return a value or raise Invalid_argument; any other
         exception is a bug per http_date.mli. *)
      prop "decode does not crash"
        Gen.(one_of [ string; near_miss ])
        (fun s ->
          match Http_date.decode s with
          | _ -> ()
          | exception Invalid_argument _ -> ());
      (* If decode succeeds, re-encoding and re-decoding yields the same
         value. *)
      prop "decode-encode stable" near_miss (fun s ->
          match Http_date.decode s with
          | exception Invalid_argument _ -> reject ()
          | t -> round_trip t);
      prop "IMF round-trip" imf_t round_trip;
      prop "RFC850 round-trip" rfc850_t round_trip;
      prop "ASCTIME round-trip" asctime_t round_trip;
    ]

(* -- Examples -- *)

let corpus =
  [
    ("Sun, 06 Nov 1994 08:49:37 GMT", `IMF (`Sun, (1994, 11, 6), (8, 49, 37)));
    ("Sunday, 06-Nov-94 08:49:37 GMT", `RFC850 (`Sun, (94, 11, 6), (8, 49, 37)));
    ("Sun Nov  6 08:49:37 1994", `ASCTIME (`Sun, (1994, 11, 6), (8, 49, 37)));
    ("Sun Nov 16 08:49:37 1994", `ASCTIME (`Sun, (1994, 11, 16), (8, 49, 37)));
    ("Mon, 01 Jan 2000 00:00:00 GMT", `IMF (`Mon, (2000, 1, 1), (0, 0, 0)));
    ("Saturday, 01-Jan-00 00:00:00 GMT", `RFC850 (`Sat, (0, 1, 1), (0, 0, 0)));
    ("Fri Dec 31 23:59:59 9999", `ASCTIME (`Fri, (9999, 12, 31), (23, 59, 59)));
    ("Tue, 15 Mar 2022 12:30:00 GMT", `IMF (`Tue, (2022, 3, 15), (12, 30, 0)));
    ( "Wednesday, 25-Dec-99 18:00:00 GMT",
      `RFC850 (`Wed, (99, 12, 25), (18, 0, 0)) );
    ("Thu Jan 10 06:15:45 2008", `ASCTIME (`Thu, (2008, 1, 10), (6, 15, 45)));
    (* asctime pads a single-digit day with a space *)
    ("Sun Nov  1 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 1), (0, 0, 0)));
    ("Sun Nov  9 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 9), (0, 0, 0)));
    ("Sun Nov 10 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 10), (0, 0, 0)));
    ("Sun Nov 28 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 28), (0, 0, 0)));
  ]

let malformed =
  [
    "";
    "XXX, 06 Nov 1994 08:49:37 GMT";
    "Sun, 06 Xxx 1994 08:49:37 GMT";
    "Sun, 06 Nov 1994 08:49:37 PST";
    "Sun, 6 Nov 1994 08:49:37 GMT";
    "Sunday, 06-Nov-1994 08:49:37 GMT";
  ]

let examples =
  group "examples"
    [
      cases "decodes and round-trips" ~name:fst corpus (fun (input, expected) ->
          equal http_date expected (Http_date.decode input);
          equal string input (Http_date.encode expected));
      cases "rejects malformed input" ~name:(Printf.sprintf "%S") malformed
        (fun input ->
          raises_match Exn.invalid_arg (fun () -> Http_date.decode input));
    ]

let () = exit (run "http-date" [ examples; properties ])
