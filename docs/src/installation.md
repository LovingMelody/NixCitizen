# Installation

This is a setup guide for nix flakes. If you would like to learn flakes, I
recommend the [Nixos & Flakes Book (unofficial)][flake-book].

## Packages

| Package             | Description                                                                                                                                 |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| star-citizen        | Star Citizen Package (wine-ge)                                                                                                              |
| star-citizen-umu    | Star Citizen package (umu-launcher)                                                                                                         |
| star-citizen-helper | Star Ctizien helper utility, clears shaders if an update is detected                                                                        |
| lug-helper          | Star Citizen's Linux User group helper. Includes a script for install if you want to use lutris instead of one of the star-citizen packages |

## NixOS

There are a few options to utilize this flake in your system.

```nix
{
  inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-citizen.url = "github:LovingMelody/nix-citizen";
  };
  outputs = { nixpkgs, nix-citizen, ... }: {
    nixosConfigurations.HOST = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            nix-citizen.nixosModules.StarCitizen
        # Optionally, just install the package
        {
            nixpkgs.overlays = [
                nix-citizen.overlays.default
            ];
            environment.systemPackages = with pkgs; [
                # Latest package, uses umu
                star-citizen-umu
                # Legacy, uses wine-ge
                # star-citizen
            ];
        }
        ./configuration.nix
        ];
    };
  };
}
```

<small>Minimal `flake.nix` for a Nixos configuration.</small>

## Homemanager

I haven't written any [home manager][nix-hm] modules, a PR for it is welcome.
For now, the package options are available.

```nix
{
  inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-citizen.url = "github:LovingMelody/nix-citizen";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nix-citizen, home-manager, ... }: {
    homeConfigurations.HOST =
    let system = "x86_64-linux";
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        {
            nixpkgs.overlays = [
                nix-citizen.overlays.default
            ];
            home.packages = with pkgs; [
                # Latest package, uses umu
                star-citizen-umu
                # Legacy, uses wine-ge
                # star-citizen
            ];
        }
        ./home.nix
      ];
    };
  };
}
```

<small>Minimal `flake.nix` configuration for home-mamanger

[flake-book]: https://nixos-and-flakes.thiscute.world/
[nix-hm]: https://nix-community.github.io/home-manager/#ch-nix-flakes
