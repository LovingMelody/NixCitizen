{
  description = "Nix Flake to simplify running Star Citizen";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-github-actions = {
      url = "github:nix-community/nix-github-actions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    # umu = {
    #   url = "git+https://github.com/Open-Wine-Components/umu-launcher/?ref=nix&dir=packaging\/nix&submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    { self, systems, ... }@inputs:
    with inputs;
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system: f (nixpkgs.legacyPackages.${system}.extend self.overlays.default)
        );
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      overlays.default = (import ./overlays.nix) inputs;
      nixosModules.StarCitizen = (import ./modules/nixos/star-citizen) self;
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
      packages = eachSystem (pkgs: {
        inherit (pkgs)
          umu
          star-citizen-helper
          lug-helper
          star-citizen
          star-citizen-umu
          dxvk-gplasync
          ;
        docs = import ./docs {
          inherit pkgs inputs;
          inherit (inputs.nixpkgs) lib;
        };
      });
      githubActions = nix-github-actions.lib.mkGithubMatrix {
        checks =
          (nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.checks)
          // (nixpkgs.lib.getAttrs [ "x86_64-linux" ] self.packages);
      };
    };
}
