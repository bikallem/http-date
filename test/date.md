# Http_date

```ocaml
open Http_date;;
#install_printer Ptime.pp;;
```

## IMF date decoding

```ocaml
# let imf_fixdate = Date.decode "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : Date.t = ((1994, 11, 6), (8, 49, 37))
```

## RFC850 date decoding
```ocaml
# let rfc850_date = Date.decode "Sunday, 06-Nov-94 08:49:37 GMT" ;;
val rfc850_date : Date.t = ((94, 11, 6), (8, 49, 37))
```

## ASCTIME date

Decode ASCTIME specified date format.

```ocaml
# let asctime_date = Date.decode "Sun Nov  6 08:49:37 1994" ;;
val asctime_date : Date.t = ((1994, 11, 6), (8, 49, 37))
```
