# HTTP Date

HTTP timestamp decoders and encoders complaint to RFC 9110 (HTTP Semantics).

The current supported formats for decoding/encoding are as follows:
  - IMF(Internet Message Format) date, eg `Sun, 06 Nov 1994 08:49:37 GMT`
  - RFC 850 date, eg `Sunday, 06-Nov-94 08:49:37 GMT`
  - asctime date, eg `Sun Nov  6 08:49:37 1994`

API usage:

 - Decoding IMF fixdate formatted timestamp values:

```ocaml
# let d = Http_date.decode "Sun, 06 Nov 1994 08:49:37 GMT" ;;
val d : Http_date.t = <abstr>

# Http_date.year d ;;
- : int = 1994

# Http_date.month d ;;
- : Http_date.month = `Nov

# Http_date.encode d ;;
- : string = "Sun, 06 Nov 1994 08:49:37 GMT"
```

References:
- [HTTP RFC 9110, section 5.6.7](https://datatracker.ietf.org/doc/html/rfc9110#section-5.6.7)

# Installation

```
opam install http-date
```

# Using in Dune

Specify the dependency in dune `executable` or `library` stanza as follows:

- `executable`

```
(executable
  (name hello)
  (libraries http-date))
```

- `library`

```
 (library
   (name hello)
   (libraries http-date))
```
