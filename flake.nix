{
  description = "http-date — RFC 9110 HTTP datetime encoder/decoder";

  inputs.nixpkgs.url = "github:nix-ocaml/nix-overlays";

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
          basePkgs = nixpkgs.legacyPackages.${system};
          pkgs = basePkgs.extend (
            _: _: {
              ocamlPackages = basePkgs.ocamlPackages.overrideScope (
                _: osuper: {
                  dune_3 = osuper.dune_3.overrideAttrs (_: {
                    version = "3.22.1";
                    src = builtins.fetchurl {
                      url = "https://github.com/ocaml/dune/releases/download/3.22.1/dune-3.22.1.tbz";
                      sha256 = "1za79mc2x2nwz45dlkad272pls7x4i02khn2hrl45v1jdhwrh2qc";
                    };
                  });
                }
              );
            }
          );
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs.ocamlPackages; [
              ocaml
              dune_3
              findlib
              ptime
              menhir
              mdx
              ocaml-lsp
              ocamlformat
            ];
          };
        }
      );
    };
}
