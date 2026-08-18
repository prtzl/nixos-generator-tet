{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "github:prtzl/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    # nixpkgs is up-to date. No need to build myself this
    # waybar = {
    #   url = "github:Alexays/Waybar";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland/v0.55.4";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Mine
    nvimnix.url = "github:prtzl/nvimnix";
    # nvimnix.url = "/home/matej/projects/git/nvimnix";

    jlink = {
      url = "github:prtzl/jlink-nix";
      # url = "/home/matej/projects/git/jlink-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, disko, ... }:
    let
      version = "26.05";
      lib = import ./lib { inherit inputs version; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {

      flake = {
        nixosConfigurations = lib.collectHosts;
      };

      systems = builtins.attrNames disko.packages;

      perSystem =
        { pkgs, system, ... }:
        let
          disko-pkg = disko.packages.${system}.default;
          installers = lib.collectInstallers;
        in
        {
          formatter = pkgs.nixfmt-tree;

          packages = {
            disko = disko-pkg;
          }
          // installers;

          devShells.default = pkgs.mkShellNoCC {
            buildInputs = [ disko-pkg ];
          };
        };
    };
}
