{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvimnix.url = "github:prtzl/nvimnix";
    # nvimnix.url = "/home/matej/projects/git/nvimnix";
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, disko, ... }:
    let
      version = "25.05";

      externalModules = with inputs; [
        disko
        nix-monitored
        nvimnix
      ];

      lib = import ./lib { inherit inputs version externalModules; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {

      flake = {
        nixosConfigurations = lib.collectHosts;
      };

      systems = builtins.attrNames disko.packages;
      perSystem =
        { pkgs, system, ... }:
        {
          packages.disko = disko.packages.${system}.default;
        };
    };
}
