# Credits:
# https://github.com/Open-Wine-Components/umu-launcher/blob/main/packaging/nix/umu-launcher.nix
{
  meson,
  ninja,
  scdoc,
  git,
  python3,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "umu-launcher";
  src = fetchFromGitHub {
    owner = "Open-Wine-Components";
    repo = "umu-launcher";
    fetchSubmodules = true;
    # June 6th 2024
    rev = "8dbaee35a2b193905c08a91203779d4bb6cbb924";
    hash = "sha256-PFCzgM4cGnRn6Usq5kMp+iT6fPPQO5FeoGJ8zZ/XzCs=";
  };
  buildInputs = [
    meson
    ninja
    scdoc
    git
  ];
  propagatedBuildInputs = [ python3 ];
  dontUseMesonConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;
  configureScript = "./configure.sh";
}
