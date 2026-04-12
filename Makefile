.PHONY: build test fuzz afl-fuzz

build:
	dune build

# Run mdx + fuzz property tests (quick, random -works from any shell)
test:
	dune test

# Run AFL fuzzing for 60s inside the fuzz shell.
# Uses nix develop to enter .#fuzz automatically - no direnv switch needed
fuzz:
	nix develop .#fuzz -c dune build @fuzz

# Builds and executes afl-fuzz binary showing its TUI
afl-fuzz: build
	cd _build/afl/fuzz && \
	./fuzz.exe --gen-corpus corpus && \
	afl-fuzz -V 60 -i corpus -o _fuzz -- ./fuzz.exe @@