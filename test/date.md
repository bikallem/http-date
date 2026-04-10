# Http_date

```ocaml
open Http_date;;
#install_printer Ptime.pp;;
```

## Short Day

```ocaml
# let imf_fixdate = Date.decode "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val imf_fixdate : Ptime.t = 1994-11-06 08:49:37 +00:00
```
