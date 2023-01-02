(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
   Distributed under the MPL-2.0 license.
   See (https://www.mozilla.org/media/MPL/2.0/index.815ca599c9df.txt).
  ---------------------------------------------------------------------------*)

(** HTTP timestamp decoders and encoders complaint to RFC 9110 (HTTP Semantics).

    The current supported formats for decoding/encoding are as follows:

    - IMF(Internet Message Format) date, eg ["Sun, 06 Nov 1994 08:49:37 GMT"]
    - RFC 850 date, eg ["Sunday, 06-Nov-94 08:49:37 GMT"]
    - asctime date, eg ["Sun Nov  6 08:49:37 1994"]

    {b References}

    - RFC 9110. {{:https://datatracker.ietf.org/doc/html/rfc9110#section-5.6.7}
      {e Date/Time Formats}} *)

(** {1 HTTP Timestamp values} *)

type t
(** Represents a successfully decoded or created HTTP timestamp value. *)

type day_name = [ `Mon | `Tue | `Wed | `Thu | `Fri | `Sat | `Sun ]
(** Name of the day in a week. *)

type month =
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
(** Month of a year. *)

(** {1:decode Decoding/Create HTTP timestamps} *)

val create :
  day_name:day_name ->
  day:int ->
  month:month ->
  year:int ->
  hour:int ->
  minute:int ->
  second:int ->
  t
(** [create] is [t] if given values are all valid.

    Valid values for the parameters are as follows:

    - [day] is [>= 1 && <= 31]
    - [year] is [>=1 && <= 9999]
    - [hour] is [>=0 && <= 23]
    - [minute] is [>=0 && <= 59]
    - [second] is [>=0 && <= 59]

    @raise Invalid_argument
      if a given value to [create] is invalid. The description text specifies
      the reason. *)

val decode : string -> t
(** [decode s] is [t] if [s] contains a valid textual representation of [t].

    {e Decoding string in IMF fix date format.}

    {[
      Http_date.decode "Sun, 06 Nov 1994 08:49:37 GMT"
    ]}
    @raise Invalid_argument
      if [s] contains one or more invalid values. See {!create}. *)

(** {1:encode Encode HTTP timestamps} *)

type encode_fmt = [ `IMF_fixdate | `RFC850_date | `ASCTIME_date ]
(** Encoding format specification for {!val:encode}. *)

val encode : ?encode_fmt:encode_fmt -> t -> string
(** [encode ?encode_fmt t] encodes [t] into a given [encode_fmt] textual
    representation. *)

(** {1 Retrieve timestamp details} *)

val day_name : t -> day_name
val day : t -> int
val month : t -> month
val year : t -> int
val hour : t -> int
val minute : t -> int
val second : t -> int

(** {1 Pretty Printing timestamps} *)

val pp : ?encode_fmt:encode_fmt -> Format.formatter -> t -> unit
