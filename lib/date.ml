type decoder = { buf : string; mutable pos : int }
type day = Mon | Tue | Wed | Thu | Fri | Sat | Sun

let advance d n : unit = d.pos <- d.pos + n

let day_name d : day =
  let day = String.sub d.buf d.pos 3 in
  let day =
    match day with
    | "Mon" -> Mon
    | "Tue" -> Tue
    | "Wed" -> Wed
    | "Thu" -> Thu
    | "Fri" -> Fri
    | "Sat" -> Sat
    | "Sun" -> Sun
    | _ -> Printf.sprintf "Invalid day value '%s'" day |> invalid_arg
  in
  advance d 3;
  day

let decode s : day =
  let d = { buf = s; pos = 0 } in
  day_name d
