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
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # nixpkgs builds mdx against a stripped-down `logs` (no lwt/jsoo) to
          # break a dep cycle. utop pulls in the full `logs`, so the two
          # propagated copies collide in the dev shell. Force mdx onto the
          # default `logs` to keep findlib happy.
          ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_4.overrideScope (
            oself: osuper: {
              mdx = osuper.mdx.override { inherit (oself) logs; };
            }
          );

          # nixpkgs ships dune 3.21.1; build the 3.22.1 binary standalone so
          # the rest of ocamlPackages (ocaml-lsp, etc.) keeps its matching
          # dune monorepo libraries.
          dune = ocamlPackages.dune_3.overrideAttrs (_: rec {
            version = "3.22.2";
            src = pkgs.fetchurl {
              url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
              hash = "sha256-wsz4vGsXr6R8RQKXNXSWMDqnyGgOMpt52Yxo41AToRg=";
            };
          });
        in
        {
          default = pkgs.mkShell {
            packages = [
              dune
              ocamlPackages.ocaml
              ocamlPackages.findlib
              ocamlPackages.ptime
              ocamlPackages.menhir
              ocamlPackages.mdx
              ocamlPackages.ocaml-lsp
              ocamlPackages.ocamlformat
              ocamlPackages.utop
            ];
          };
        }
      );
    };
}
