.PHONY: build test mutate

build:
	dune build

# Run expect and property tests
test:
	dune test

# Mutation testing: run every suite against each mutant of lib/ and report
# the mutants no test fails on.
mutate: build
	WINDTRAP_MUTATE=1 dune runtest --force --instrument-with ppx_windtrap.mutate
	dune exec windtrap -- mutants
