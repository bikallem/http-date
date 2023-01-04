## Http_date decode/encode tests

## Setup

```ocaml
# let std = Format.std_formatter ;;
val std : Format.formatter = <abstr>
```

### IMF fixdate

Decode IMF (Internet Message Format) fixdate.


```ocaml
# let imf_fixdate = "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : string = "Sun, 06 Nov 1994 08:49:37 GMT"

# let d = Http_date.decode imf_fixdate ;;
val d : Ptime.t = <abstr>
```

Encode IMF fixdate value.

```ocaml
# let s = Http_date.(encode ~encoding:IMF d) ;;
val s : string = "Sun, 06 Nov 1994 08:49:37 GMT"

# String.equal imf_fixdate s ;;
- : bool = true
```

Pretty-print IMF fixdate.

```ocaml
# Http_date.pp std d ;;
Sun, 06 Nov 1994 08:49:37 GMT
- : unit = ()
```

### RFC850 date

Decode RFC-850 specified date format.

```ocaml
# let rfc850_date = "Sunday, 06-Nov-94 08:49:37 GMT" ;;
val rfc850_date : string = "Sunday, 06-Nov-94 08:49:37 GMT"

# let d = Http_date.decode ~century:19 rfc850_date ;;
val d : Ptime.t = <abstr>

# Ptime.to_date_time d ;;
- : Ptime.date * Ptime.time = ((1994, 11, 6), ((8, 49, 37), 0))
```

Encode RFC850 date.

```ocaml
# let s = Http_date.(encode ~encoding:RFC850 d) ;;
val s : string = "Sunday, 06-Nov-94 08:49:37 GMT"

# String.equal rfc850_date s ;;
- : bool = true
```

Pretty-print RFC850 date.

```ocaml
# Http_date.(pp ~encoding:RFC850 std d) ;;
Sunday, 06-Nov-94 08:49:37 GMT
- : unit = ()
```

### ASCTIME date

Decode ASCTIME specified date format.

```ocaml
# let asctime_date = "Sun Nov  6 08:49:37 1994" ;;
val asctime_date : string = "Sun Nov  6 08:49:37 1994"

# let d = Http_date.decode asctime_date ;;
val d : Ptime.t = <abstr>
```

Encode ASCTIME date.

```ocaml
# let s = Http_date.(encode ~encoding:ASCTIME d) ;;
val s : string = "Sun Nov  6 08:49:37 1994"

# String.equal asctime_date s ;;
- : bool = true
```

Pretty-print ASCTIME date.

```ocaml
# Http_date.(pp ~encoding:ASCTIME std d) ;;
Sun Nov  6 08:49:37 1994
- : unit = ()
```
