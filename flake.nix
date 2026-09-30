{
  description = "http-date — RFC 9110 HTTP datetime encoder/decoder";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        # First entry compiles OCaml 5.5.1 and the packages built on it (no
        # binary cache hit); later entries are instant.
        default =
          let
            # nixpkgs ships OCaml 5.5.0 and dune 3.23.1.
            ocaml = pkgs.ocaml-ng.ocamlPackages_5_5.ocaml.overrideAttrs (_: rec {
              version = "5.5.1";
              src = pkgs.fetchurl {
                url = "https://caml.inria.fr/pub/distrib/ocaml-5.5/ocaml-${version}.tar.xz";
                hash = "sha256-zQqXvb/JnwD1P07khJGWTHNievsJ7Y5N4jC6RIij1rk=";
              };
            });

            scope = (pkgs.ocaml-ng.mkOcamlPackages ocaml).overrideScope (
              final: prev:
              let
                windtrapSrc = pkgs.fetchurl {
                  url = "https://github.com/invariant-hq/windtrap/releases/download/v0.2.0/windtrap-0.2.0.tbz";
                  hash = "sha256-LmGob4yXUCwfilk8KOJV1ZGkSxUzxu7YzQyEevo9dyo=";
                };
                windtrapMeta = {
                  homepage = "https://github.com/invariant-hq/windtrap";
                  license = pkgs.lib.licenses.isc;
                };
              in
              {
                # Merlin's version table is keyed on exact compiler versions;
                # the 5.5.0 release supports 5.5.1.
                merlin = prev.merlin.override { version = "5.8-505"; };

                windtrap = final.buildDunePackage {
                  pname = "windtrap";
                  version = "0.2.0";
                  src = windtrapSrc;
                  doCheck = false;
                  meta = windtrapMeta // {
                    description = "Unit, property, stateful and expect tests behind one API";
                  };
                };

                ppx_windtrap = final.buildDunePackage {
                  pname = "ppx_windtrap";
                  version = "0.2.0";
                  src = windtrapSrc;
                  propagatedBuildInputs = [
                    final.windtrap
                    final.ppxlib
                  ];
                  doCheck = false;
                  meta = windtrapMeta // {
                    description = "Inline expect tests, coverage and mutation testing for windtrap";
                  };
                };
              }
            );

            # Only the dune binary is upgraded; the dune libraries that other
            # packages link against stay at the nixpkgs version.
            dune = scope.dune_3.overrideAttrs (_: rec {
              version = "3.24.2";
              src = pkgs.fetchurl {
                url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
                hash = "sha256-RyeYaRsCFtr1OHCfD0cDs2F+8krQhmyQlgaLqrpNdio=";
              };
            });
          in
          pkgs.mkShell {
            packages = [ dune ] ++ (with scope; [
              ocaml
              findlib
              ocaml-lsp
              ocamlformat
              utop
              windtrap
              ppx_windtrap
            ]);
          };
      });
    };
}
