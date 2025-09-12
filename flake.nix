{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;

      my = import ./lib/my-system.nix {
        inherit lib nixpkgs home-manager;
      };

      collectHosts = import ./lib/collect-hosts.nix {
        inherit lib my;
        inputs = self.inputs;
      };
    in
    {
      nixosConfigurations = collectHosts;
    };
}
