## Http_date decode/encode tests

Decode IMF (Internet Message Format) fixdate.


```ocaml
# let imf_fixdate = "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : string = "Sun, 06 Nov 1994 08:49:37 GMT"

# let d = Http_date.decode imf_fixdate ;;
val d : Http_date.t = <abstr>

# String.equal imf_fixdate (Http_date.encode d) ;;
- : bool = true
```

Encode IMF fixdate value.

```ocaml
# Http_date.pp Format.std_formatter d ;;
Sun, 06 Nov 1994 08:49:37 GMT
- : unit = ()
```
