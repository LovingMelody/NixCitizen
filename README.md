# nix-citizen - A Star Citizen helper flake

![Helper Flake Logo](logo.png)

## Install & Run

Recommended to setup cache if you are using the star-citizen package.
Instructions can be found upstream at
[fufexan/nix-gaming](https://github.com/fufexan/nix-gaming#install--run).

While it is possible to install this without using nix flakes. I'm not familiar
with this and cannot provide assistance. If you would like to learn how to use
flakes please see the
[Nixos & Flakes Book (unoffical)](https://nixos-and-flakes.thiscute.world/)

### Whats included in this flake

| Package                                                                             | Description                                                                                                                            |
| ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [star-citizen](https://github.com/fufexan/nix-gaming/tree/master/pkgs/star-citizen) | Star Citizen game (standalone) This package is repackaged from nix-gaming                                                              |
| [star-citizen-helper](./pkgs/star-citizen-helper)                                   | Star Citizen helper utility, clears shaders if an update is detected                                                                   |
| [lug-helper](./pkgs/lug-helper)                                                     | Star Citizen's Linux Users Group Helper Script. Includes a setup script if you wish to use lutris instead of the star-citizen package. |

### Cachix

Build caches are available

```nix
# configuration.nix
{
    nix.settings = {
        substituters = ["https://nix-citizen.cachix.org"];
        trusted-public-keys = ["nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="];
    };
}
```

## Tips

To access the [Wine Control Panel](https://wiki.winehq.org/Control) (ex. editing
Joystick overrides) run the following:

```bash
# Adjust WINEPREFIX to your installation directory, otherwise use this default path
WINEPREFIX=$HOME/Games/star-citizen nix run github:fufexan/nix-gaming#wine-ge -- control
```

Likewise for [winecfg](https://wiki.winehq.org/Winecfg) (ex. registry edits,
some graphics settings):

```bash
WINEPREFIX=$HOME/Games/star-citizen nix run github:fufexan/nix-gaming#wine-ge -- winecfg
```

## Credits

- [starcitizen-lug/lug-helper](https://github.com/starcitizen-lug/lug-helper) -
  Layed the ground work for the star-citizen package
- [fufexan/nix-gaming](https://github.com/fufexan/nix-gaming) - Maintaining
  Wine-GE & DXVK packages
- [Open-Wine-Components/umu-launcher](Open-Wine-Components/umu-launcher) -
  Unified Linux Wine Game Launcher (Also has definitions for nix packaging)
