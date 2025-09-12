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
      nixpkgs = inputs.nixpkgs;
      home-manager = inputs.home-manager;
      lib = nixpkgs.lib // (import ./lib/utils.nix { inherit lib; });

      externalModules = [
        inputs.nvimnix
        # inputs.nix-monitored
      ];

      my = import ./lib/my-system.nix {
        inherit
          lib
          nixpkgs
          home-manager
          externalModules
          version
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
