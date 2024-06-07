# Credits:
# https://github.com/Open-Wine-Components/umu-launcher/blob/main/packaging/nix/umu-run.nix
{
  umu-launcher,
  lib,
  stdenv,
  buildFHSEnv,
  writeShellScript,
  ...
}:
buildFHSEnv {
  name = "umu";
  runScript =
    let
      ldPath = [ "/lib32" ] ++ lib.optional stdenv.is64bit "/lib64";
    in
    writeShellScript "umu-env" ''
      export LD_LIBRARY_PATH=${lib.concatStringsSep ":" ldPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
      ${umu-launcher}/bin/umu-run "$@"
    '';
}
