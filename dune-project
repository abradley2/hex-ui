(lang dune 3.8)

(name hex-ui)

(using melange 0.1)

(generate_opam_files true)

(source
 (github abradley2/hex-ui))

(authors "Anthony Bradley")

(maintainers "Anthony Bradley")

(license MIT)

(documentation https://github.com/abradley2/hex-ui)

(package
 (name hex_ui)
 (synopsis "Cycle.js bindings for Melange applications")
 (description "Cycle.js bindings for Melange applications")
 (depends ocaml dune)
 (tags
  ("Cycle.js" "Frontend" "SPA")))

(package
 (name examples)
 (synopsis "")
 (description "")
 (depends ocaml dune hex_ui)
 (tags
  ("Cycle.js" "Frontend" "SPA")))


; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
