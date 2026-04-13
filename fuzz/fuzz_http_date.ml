open Alcobar
open Alcobar.Syntax

(* -- Generators for valid Http_date.t values -- *)

(* `dayname` is independent of `(y,m,d)`: the codec preserves whatever weekday
   the input carries without cross-checking. Round-trip still holds. *)
let dayname : Http_date.dayname gen =
  choose
    [
      const `Mon;
      const `Tue;
      const `Wed;
      const `Thu;
      const `Fri;
      const `Sat;
      const `Sun;
    ]

let month : int gen = range ~min:1 12

(* `day` capped at 28: the parser doesn't validate day-of-month vs month, but 28
   is safe for all months so round-trips never depend on calendar logic. *)
let day : int gen = range ~min:1 28
let hour : int gen = range 24
let minute : int gen = range 60
let second : int gen = range 60

let time : Http_date.time gen =
  let+ h = hour and+ m = minute and+ s = second in
  (h, m, s)

let date4 : Http_date.date gen =
  let+ y = range 10_000 and+ m = month and+ d = day in
  (y, m, d)

(* RFC 850 uses `date2` (0–99): encoder emits `%02i`, parser reads exactly 2
   digits ([lib/http_date.ml:147](lib/http_date.ml#L147)). Anything >= 100 would
   break the round-trip. *)
let date2 : Http_date.date gen =
  let+ y = range 100 and+ m = month and+ d = day in
  (y, m, d)

let imf_t : Http_date.t gen =
  map [ dayname; date4; time ] (fun dn d t -> `IMF (dn, d, t))

let rfc850_t : Http_date.t gen =
  map [ dayname; date2; time ] (fun dn d t -> `RFC850 (dn, d, t))

let asctime_t : Http_date.t gen =
  map [ dayname; date4; time ] (fun dn d t -> `ASCTIME (dn, d, t))

(* Property 1: decode must either return a value or raise Invalid_argument. Any
   other exception is a bug per http_date.mli. *)
let test_decode_no_crash input : unit =
  match Http_date.decode input with
  | _ -> ()
  | exception Invalid_argument _ -> ()

(* Property 2: if decode succeeds, re-encoding and re-decoding must yield the
   same value. Invalid inputs are discarded via bad_test. *)
let test_decode_encode_stable input =
  match Http_date.decode input with
  | exception Invalid_argument _ -> bad_test ()
  | t -> begin
      let s = Http_date.encode t in
      match Http_date.decode s with
      | t' -> check_eq ~pp:Http_date.pp t t'
      | exception Invalid_argument _ ->
          failf "encode produced a string decode rejected: %s" s
    end

let round_trip t =
  let s = Http_date.encode t in
  check_eq ~pp:Http_date.pp t (Http_date.decode s)

let expect_invalid_arg f =
  match f () with
  | _ -> fail "expected Invalid_argument"
  | exception Invalid_argument _ -> ()

let test_corpus () =
  let cases =
    [
      ("Sun, 06 Nov 1994 08:49:37 GMT", `IMF (`Sun, (1994, 11, 6), (8, 49, 37)));
      ( "Sunday, 06-Nov-94 08:49:37 GMT",
        `RFC850 (`Sun, (94, 11, 6), (8, 49, 37)) );
      ("Sun Nov  6 08:49:37 1994", `ASCTIME (`Sun, (1994, 11, 6), (8, 49, 37)));
      ("Sun Nov 16 08:49:37 1994", `ASCTIME (`Sun, (1994, 11, 16), (8, 49, 37)));
      ("Mon, 01 Jan 2000 00:00:00 GMT", `IMF (`Mon, (2000, 1, 1), (0, 0, 0)));
      ("Saturday, 01-Jan-00 00:00:00 GMT", `RFC850 (`Sat, (0, 1, 1), (0, 0, 0)));
      ("Fri Dec 31 23:59:59 9999", `ASCTIME (`Fri, (9999, 12, 31), (23, 59, 59)));
      ("Tue, 15 Mar 2022 12:30:00 GMT", `IMF (`Tue, (2022, 3, 15), (12, 30, 0)));
      ( "Wednesday, 25-Dec-99 18:00:00 GMT",
        `RFC850 (`Wed, (99, 12, 25), (18, 0, 0)) );
      ("Thu Jan 10 06:15:45 2008", `ASCTIME (`Thu, (2008, 1, 10), (6, 15, 45)));
    ]
  in
  List.iter
    (fun (input, expected) ->
      check_eq ~pp:Http_date.pp expected (Http_date.decode input);
      round_trip expected)
    cases

let test_asctime_day_width () =
  let cases =
    [
      ("Sun Nov  1 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 1), (0, 0, 0)));
      ("Sun Nov  9 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 9), (0, 0, 0)));
      ("Sun Nov 10 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 10), (0, 0, 0)));
      ("Sun Nov 28 00:00:00 2000", `ASCTIME (`Sun, (2000, 11, 28), (0, 0, 0)));
    ]
  in
  List.iter
    (fun (input, expected) ->
      check_eq ~pp:Http_date.pp expected (Http_date.decode input);
      round_trip expected)
    cases

let test_malformed () =
  let cases =
    [
      "";
      "XXX, 06 Nov 1994 08:49:37 GMT";
      "Sun, 06 Xxx 1994 08:49:37 GMT";
      "Sun, 06 Nov 1994 08:49:37 PST";
      "Sun, 6 Nov 1994 08:49:37 GMT";
      "Sunday, 06-Nov-1994 08:49:37 GMT";
    ]
  in
  List.iter
    (fun input -> expect_invalid_arg (fun () -> Http_date.decode input))
    cases

let suite =
  ( "http_date",
    [
      test_case "decode does not crash" [ bytes ] test_decode_no_crash;
      test_case "decode-encode stable" [ bytes ] test_decode_encode_stable;
      test_case "IMF round-trip" [ imf_t ] round_trip;
      test_case "RFC850 round-trip" [ rfc850_t ] round_trip;
      test_case "ASCTIME round-trip" [ asctime_t ] round_trip;
      test_case "corpus" [ const () ] test_corpus;
      test_case "ASCTIME day width" [ const () ] test_asctime_day_width;
      test_case "malformed inputs" [ const () ] test_malformed;
    ] )
