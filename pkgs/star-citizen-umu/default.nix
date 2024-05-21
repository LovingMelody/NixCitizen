{
  lib,
  pkgs,
  fetchurl,
  writeShellScriptBin,
  makeDesktopItem,
  symlinkJoin,
  callPackage,
  proton-ge-bin,
  umu,
  gamemode,
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pname ? "star-citizen",
  location ? "$HOME/Games/star-citizen",
}:
let
  version = "1.6.10";
  src = fetchurl {
    url = "https://install.robertsspaceindustries.com/star-citizen/RSI-Setup-${version}.exe";
    name = "RSI-Setup-${version}.exe";
    hash = "sha256-axttJvw3MFmhLC4e+aqtf4qx0Z0x4vz78LElyGkMAbs=";
  };

  # Powershell stub for star-citizen
  powershell-stub = callPackage ./powershell-stub.nix { };

  script = writeShellScriptBin pname ''
    export WINEPREFIX="${location}"
    export PROTONPATH="${proton-ge-bin.steamcompattool}/"
    export GAMEID="umu-starcitizen"
    export STORE="none"
    export EOS_USE_ANTICHEATCLIENTNULL=1
    export WINE_HIDE_NVIDIA_GPU=1
    export __GL_SHADER_DISK_CACHE=${if enableGlCache then "1" else "0"}
    export __GL_SHADER_DISK_CACHE_SIZE=${toString glCacheSize}
    export dual_color_blend_by_location="true"
    export USER="$(whoami)"
    export PATH=${
      lib.makeBinPath [
        umu
        gamemode
      ]
    }:$PATH
    export RSI_LAUNCHER="$WINEPREFIX/drive_c/Program Files/Roberts Space Industries/RSI Launcher/RSI Launcher.exe"

    if [ ! -f "$RSI_LAUNCHER" ]; then
      umu "${src}" /S
    fi

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi
    cd $WINEPREFIX

    ${powershell-stub}/bin/install.sh

    ${preCommands}
    gamemoderun umu "$RSI_LAUNCHER" "$@"

    ${postCommands}

  '';

  icon = pkgs.fetchurl {
    # Source: https://lutris.net/games/icon/star-citizen.png
    url = "https://github-production-user-asset-6210df.s3.amazonaws.com/17859309/255031314-2fac3a8d-a927-4aa9-a9ad-1c3e14466c20.png";
    hash = "sha256-19A1DyLQQcXQvVi8vW/ml+epF3WRlU5jTmI4nBaARF0=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    comment = "Star Citizen - Alpha";
    desktopName = "Star Citizen";
    categories = [ "Game" ];
    mimeTypes = [ "application/x-star-citizen-launcher" ];
  };
in
symlinkJoin {
  name = pname;
  paths = [
    desktopItems
    script
  ];

  meta = {
    description = "Star Citizen installer and launcher";
    homepage = "https://robertsspaceindustries.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fuzen ];
    platforms = [ "x86_64-linux" ];
  };
}
