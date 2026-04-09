# Http_date

```ocaml
open Http_date
```

## Short Day

```ocaml
# let day = List.map Date.decode ["Mon"; "Tue"; "Wed"; "Thu"; "Fri"; "Sat"; "Sun"];;
val day : Date.day list =
  [Date.Mon; Date.Tue; Date.Wed; Date.Thu; Date.Fri; Date.Sat; Date.Sun]
```
