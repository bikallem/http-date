open Alcobar

(* Property 1: decode must either return a value or raise Invalid_argument. 
   Any other exception is a bug per http_date.mli. *)
let test_decode_no_crash input : unit =
  match Http_date.decode input with
  | _ -> ()
  | exception Invalid_argument _ -> ()

(* Property 2: if decode succeeds, re-encoding and re-decoding must yield 
   the same value. Invalid inputs are discarded via bad_test. *)
let test_decode_encode_stabe input =
  match Http_date.decode input with
  | exception Invalid_argument _ -> bad_test ()
  | t -> begin
      let s = Http_date.encode t in
      match Http_date.decode s with
      | t' -> check_eq ~pp:Http_date.pp t t'
      | exception Invalid_argument _ ->
          failf "encode produced a string decode rejected: %s" s
    end

let suite =
  ( "http_date",
    [
      test_case "decode does not crash" [ bytes ] test_decode_no_crash;
      test_case "decode-encode stable" [ bytes ] test_decode_encode_stabe;
    ] )
