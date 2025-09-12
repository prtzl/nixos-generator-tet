{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvimnix.url = "github:prtzl/nvimnix";
  };

  outputs =
    {self, nixpkgs, home-manager, nvimnix, ...}:
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
