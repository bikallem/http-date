(*---------------------------------------------------------------------------
   Copyright (c) 2022 Bikal Gurung. All rights reserved.
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

    - RFC 9110. {{:https://datatracker.ietf.org/doc/html/rfc9110#section-5.6.7}
      {e Date/Time Formats}} *)

(** Encoding format specification for {!val:encode}.

    {e Note:}

    {!constructor:RFC850} and {!constructor:ASCTIME} are both considered
    obsolete. It is not advised for usage in new applications. They are both
    included here for compliance of RFC 9110 and for backwards compatibility.
    {!constructor:IMF} is the recommended format for usage. *)
type encoding =
  | IMF
      (** Internet Message Format fixdate, eg ["Sun, 06 Nov 1994 08:49:37 GMT"] *)
  | RFC850
      (** RFC 850 date, eg ["Sunday, 06-Nov-94 08:49:37 GMT"] {e Obsolete} *)
  | ASCTIME  (** asctime date, eg ["Sun Nov  6 08:49:37 1994"] {e Obsolete} *)

val decode : ?century:int -> string -> Ptime.t
(** [decode s] is [ptime] if [s] contains a valid textual representation of
    formats defined in {!type:encoding}.

    [century] An integer value representing century component of a year. This is
    used to decode the correct year component of [ptime], if [s] contains
    {e RFC 850} encoded date value, e.g. year [96] is decoded as [1996] if
    [century = 19]. If [century] is not given, then the decoded year component
    is used as is, i.e. [96].

    {e decoding string in IMF fix date format:}

    {[
      Http_date.decode "Sun, 06 Nov 1994 08:49:37 GMT"
    ]}
    @raise Invalid_argument
      if [s] contains date format not supported by {!type:encoding}. *)

(** {1:encode Encode HTTP timestamps} *)

val encode : ?encoding:encoding -> Ptime.t -> string
(** [encode ?encoding ptime] encodes [ptime] into a given [encoding] textual
    representation. The default value of [encoding] is {!constructor:IMF}. *)

(** {1 Pretty Printing timestamps} *)

val pp : ?encoding:encoding -> Format.formatter -> Ptime.t -> unit
(** [pp ?encoding fmt ptime] is like [encode ?encoding ptime] except it prints
    out to [fmt] instead of a string. *)
