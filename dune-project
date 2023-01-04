(lang dune 3.6)

(name http-date)

(using menhir 2.0)

(using mdx 0.3)

(generate_opam_files true)

(source
 (github bikallem/http-date))

(authors "Bikal Lem")

(maintainers "Bikal Lem")

(license MPL-2.0)

(package
 (name http-date)
 (synopsis "HTTP Datetime encoder/decoder")
 (description "RFC 9110 compliant HTTP datetime decoder and encoder")
 (depends
  (ocaml
   (>= 5.0))
  (dune
   (>= 2.6))
  (ptime
   (>= 1.1.0))
  (mdx
   (and
    (>= 2.1.0)
    :with-test))))
