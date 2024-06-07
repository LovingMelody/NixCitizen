# https://github.com/Open-Wine-Components/umu-launcher/blob/main/packaging/nix/combine.nix
{ symlinkJoin, callPackage, ... }:
let
  umu-launcher = callPackage ./umu-launcher.nix { };
  umu-run = callPackage ./umu-run.nix { inherit umu-launcher; };
in
symlinkJoin {
  name = "umu-combine";
  paths = [
    umu-launcher
    umu-run
  ];
  postBuild = ''
    rm $out/bin/umu-run;
  '';
  meta.mainProgram = "umu";
}
