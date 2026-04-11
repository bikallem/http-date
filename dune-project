(lang dune 3.22)

(name http-date)

(using mdx 0.4)

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
   (>= 4.11.0))
  dune
  (mdx
   (and
    (>= 2.1.0)
    :with-test))))
