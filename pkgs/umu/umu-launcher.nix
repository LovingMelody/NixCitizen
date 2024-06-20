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
    # June 17th 2024
    rev = "dc41d603ceae2d644c274dc94dd40f97d49325d0";
    hash = "sha256-psCA9hfFELEoPJ0kLMs+assjGtlgq2QC8HwiQBluosg=";
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
