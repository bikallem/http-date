type t = int

let of_int day =
  if day >= 1 && day <= 31 then day
  else
    raise
      (Invalid_argument
         ("Day - " ^ string_of_int day ^ ". Day must be >= 1 and <= 31"))

let of_string s = of_int (int_of_string s)
let to_string t = string_of_int t

external to_int : t -> int = "%identity"
