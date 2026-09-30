## Unreleased

### Changed

- Tests migrated from mdx and alcobar to windtrap: `let%expect_test` for the
  documented examples, `prop` for the properties, and `make mutate` for
  mutation testing. AFL fuzzing and the `mdx`/`alcobar` test dependencies are
  gone.
- Require dune 3.24 to build.

## v0.2 2026-04-13

### Breaking changes

- Replace `ocamllex`/`menhir` implementation with a hand-written parser.
- Remove `ptime` dependency — the library is now dependency-free (aside from `ocaml` and `dune`).
- New `t` type: a polymorphic variant (`IMF | `RFC850 | `ASCTIME`) tagged by
  parsed format, carrying `dayname * date * time`.
- `decode` now returns `t` (was `Ptime.t`).
- `encode` now takes `t` (was `Ptime.t * string`).

### Added

- `dayname`, `date`, `time`, and `datetime` types exposed in the public API.
- `pp` pretty-printer for `t`.
- Validate date and time values during parsing.
- Property-based tests with `alcobar` and AFL fuzz testing infrastructure.

## v0.1 2023-01-05

- Initial release supporting decoding/encoding in IMF, RFC 850 and asctime format.
