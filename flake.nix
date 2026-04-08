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
          ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_4;

          # nixpkgs ships dune 3.21.1; build the 3.22.1 binary standalone so
          # the rest of ocamlPackages (ocaml-lsp, etc.) keeps its matching
          # dune monorepo libraries.
          dune = ocamlPackages.dune_3.overrideAttrs (_: rec {
            version = "3.22.1";
            src = pkgs.fetchurl {
              url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
              hash = "sha256-DAuYOWwy7EJohsLCKUAk/Wh6xRFNTdoK+dyKLlhNR/0=";
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
            ];
          };
        }
      );
    };
}
