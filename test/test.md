# Http_Http_date

## IMF Http_date decoding

```ocaml
# let imf_fixHttp_date = Http_date.decode "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixHttp_date : Http_date.t = `IMF (`Sun, (1994, 11, 6), (8, 49, 37))
```

```ocaml
# Http_date.pp Format.std_formatter imf_fixHttp_date; Format.print_flush ();;
Sun, 06 Nov 1994 08:49:37 GMT
- : unit = ()
```

```ocaml
# Http_date.encode imf_fixHttp_date;;
- : string = "Sun, 06 Nov 1994 08:49:37 GMT"
```

## RFC850 Http_date decoding

```ocaml
# let rfc850_Http_date = Http_date.decode "Sunday, 06-Nov-94 08:49:37 GMT" ;;
val rfc850_Http_date : Http_date.t = `RFC850 (`Sun, (94, 11, 6), (8, 49, 37))
```

```ocaml
# Http_date.pp Format.std_formatter rfc850_Http_date; Format.print_flush ();;
Sunday, 06-Nov-94 08:49:37 GMT
- : unit = ()
```

```ocaml
# Http_date.encode rfc850_Http_date;;
- : string = "Sunday, 06-Nov-94 08:49:37 GMT"
```

## ASCTIME Http_date

```ocaml
# let asctime_Http_date = Http_date.decode "Sun Nov  6 08:49:37 1994" ;;
val asctime_Http_date : Http_date.t =
  `ASCTIME (`Sun, (1994, 11, 6), (8, 49, 37))
```

```ocaml
# Http_date.pp Format.std_formatter asctime_Http_date; Format.print_flush ();;
Sun Nov  6 08:49:37 1994
- : unit = ()
```

```ocaml
# Http_date.encode asctime_Http_date;;
- : string = "Sun Nov  6 08:49:37 1994"
```
