{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  makeOptionsDoc =
    configuration:
    pkgs.nixosOptionsDoc {
      inherit (configuration) options;

      # Filter out any options not beginning with `stylix`
      transformOptions =
        option: option // { visible = option.visible && builtins.elemAt option.loc 0 == "nix-citizen"; };
    };

  nixos = makeOptionsDoc (
    lib.nixosSystem {
      inherit (pkgs) system;
      modules = [ inputs.self.nixosModules.StarCitizen ];
    }
  );

in
pkgs.stdenvNoCC.mkDerivation {
  name = "stylix-book";
  src = ./.;

  patchPhase = ''
    cp ${../README.md} src/README.md
    cp ${../logo.png} src/logo.png

    # The "declared by" links point to a file which only exists when the docs
    # are built locally. This removes the links.
    sed '/*Declared by:*/,/^$/d' <${nixos.optionsCommonMark} >>src/options/nixos.md
  '';

  buildPhase = ''
    ${pkgs.mdbook}/bin/mdbook build --dest-dir $out
  '';
}
