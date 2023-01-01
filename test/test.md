## Http_date decode/encode tests

### IMF fixdate

Decode IMF (Internet Message Format) fixdate.


```ocaml
# let imf_fixdate = "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : string = "Sun, 06 Nov 1994 08:49:37 GMT"

# let d = Http_date.decode imf_fixdate ;;
val d : Http_date.t = <abstr>
```

Encode IMF fixdate value.

```ocaml
# let s = Http_date.encode ~encode_fmt:`IMF_fixdate d ;;
val s : string = "Sun, 06 Nov 1994 08:49:37 GMT"

# String.equal imf_fixdate s ;;
- : bool = true
```

Pretty-print IMF fixdate.

```ocaml
# Http_date.pp Format.std_formatter d ;;
Sun, 06 Nov 1994 08:49:37 GMT
- : unit = ()
```
