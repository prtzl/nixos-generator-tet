{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvimnix.url = "github:prtzl/nvimnix";
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      version = "25.05";

      externalModules = with inputs; [
        nvimnix
        nix-monitored
      ];

      lib = import ./lib { inherit inputs version externalModules; };

    in
    {
      nixosConfigurations = lib.collectHosts;
    };
}
