{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvimnix.url = "github:prtzl/nvimnix";
  };

  outputs =
    inputs:
    let
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager;
      lib = nixpkgs.lib;

      homeModules = [
        inputs.nvimnix
      ];

      my = import ./lib/my-system.nix {
        inherit
          lib
          nixpkgs
          home-manager
          homeModules
          ;
      };

      collectHosts = import ./lib/collect-hosts.nix {
        inherit lib my;
        inputs = inputs;
      };
    in
    {
      nixosConfigurations = collectHosts;
    };
}
