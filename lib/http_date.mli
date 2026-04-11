(*---------------------------------------------------------------------------
   Copyright (c) 2026 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)

(** HTTP timestamp decoders and encoders complaint to RFC 9110 (HTTP Semantics).

    The current supported formats for decoding/encoding are as follows:

    - IMF(Internet Message Format) date, eg ["Sun, 06 Nov 1994 08:49:37 GMT"]
    - RFC 850 date, eg ["Sunday, 06-Nov-94 08:49:37 GMT"] {e Obsolete}
    - asctime date, eg ["Sun Nov  6 08:49:37 1994"] {e Obsolete}

    {b HTTP timestamps are always in GMT/UTC}

    {b References}

    - RFC 9110.
      {{:https://datatracker.ietf.org/doc/html/rfc9110#section-5.6.7}
       {e Date/Time Formats}} *)

type dayname = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]
(** [dayname] is the day name of the week, e.g. "Mon", "Monday", "Tue" .etc *)

type date = int * int * int
(** (year, month, day) *)

type time = int * int * int
(** (hour, minute, seconds) *)

type datetime = dayname * date * time

type t =
  [ `IMF of datetime
    (** Internet Message Format fixdate, eg ["Sun, 06 Nov 1994 08:49:37 GMT"] *)
  | `RFC850 of datetime
    (** RFC 850 date, eg ["Sunday, 06-Nov-94 08:49:37 GMT"] {e Obsolete} *)
  | `ASCTIME of datetime
    (** asctime date, eg ["Sun Nov  6 08:49:37 1994"] {e Obsolete} *) ]

val decode : string -> t
(** [decode s] decodes HTTP date value in [s] to [(date, time)].

    @raise Invalid_argument
      if [s] doesn't contain valid date in the format of IMF, RFC850 or ASCTIME.
*)

val encode : t -> string
(** [encode t] is [t] in its string representation format. *)

(** {1 Pretty Printing timestamps} *)

val pp : Format.formatter -> t -> unit
(** [pp fmt t] pretty prints [t] into a HTTP date time string format. *)
