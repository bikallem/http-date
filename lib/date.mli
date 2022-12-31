module Day_name : sig
  type t = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]

  val to_string : t -> string
  val of_string : string -> t
  val of_string_long : string -> t
end

module Month : sig
  type t =
    [ `Jan
    | `Feb
    | `Mar
    | `Apr
    | `May
    | `Jun
    | `Jul
    | `Aug
    | `Sep
    | `Oct
    | `Nov
    | `Dec ]

  val to_string : t -> string
  val of_string : string -> t
end

(** Day of the month value *)
module Day : sig
  type t

  val of_int : int -> t
  (** [of_int i] is [t] if [i] is within [>=1 and <= 31].

      @raise Invalid_argument if [i] is not within the acceptable range. *)

  val of_string : string -> t
  val to_int : t -> int
  val to_string : t -> string
end
