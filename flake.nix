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
      findModules = import ./lib/utils.nix { inherit lib; };
      # This don't work ... somehow. I'm now doing this wherever I use it
      lib = nixpkgs.lib.extend (
        self: super: {
          lib = self.lib // {
            findModules = import ./lib/utils.nix { inherit (self) lib; };
          };
        }
      );

      externalModules = with inputs; [
        nvimnix
        nix-monitored
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
