# Http_date

```ocaml
open Http_date;;
#install_printer Ptime.pp;;
```

## IMF date decoding

```ocaml
# let imf_fixdate = Date.decode "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : Date.t = `IMF (`Sun, (1994, 11, 6), (8, 49, 37))
```

```ocaml
# Date.pp Format.std_formatter imf_fixdate; Format.print_flush ();;
Sun, 06 Nov 1994 08:49:37 GMT
- : unit = ()
```

```ocaml
# Date.encode imf_fixdate;;
- : string = "Sun, 06 Nov 1994 08:49:37 GMT"
```

## RFC850 date decoding

```ocaml
# let rfc850_date = Date.decode "Sunday, 06-Nov-94 08:49:37 GMT" ;;
val rfc850_date : Date.t = `RFC850 (`Sun, (94, 11, 6), (8, 49, 37))
```

```ocaml
# Date.pp Format.std_formatter rfc850_date; Format.print_flush ();;
Sunday, 06-Nov-94 08:49:37 GMT
- : unit = ()
```

```ocaml
# Date.encode rfc850_date;;
- : string = "Sunday, 06-Nov-94 08:49:37 GMT"
```

## ASCTIME date

```ocaml
# let asctime_date = Date.decode "Sun Nov  6 08:49:37 1994" ;;
val asctime_date : Date.t = `ASCTIME (`Sun, (1994, 11, 6), (8, 49, 37))
```

```ocaml
# Date.pp Format.std_formatter asctime_date; Format.print_flush ();;
Sun Nov  6 08:49:37 1994
- : unit = ()
```

```ocaml
# Date.encode asctime_date;;
- : string = "Sun Nov  6 08:49:37 1994"
```
