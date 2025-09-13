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
      # findModules = import ./lib/utils.nix { inherit lib; };
      # This don't work ... somehow. I'm now doing this wherever I use it
      # lib = import ./lib/lib {
      #   inherit inputs;
      #   inherit (nixpkgs) lib;
      # };
      # lib = nixpkgs.lib;
      lib = nixpkgs.lib.extend (
        final: prev: with builtins; rec {
          not = x: !x;
          isEmpty = x: x == null || x == "" || x == [ ] || x == { };
          isNotEmpty = x: not (isEmpty x);
          recursiveConcat = with prev; foldr recursiveUpdate { };

          foreach =
            with prev;
            xs: f:
            recursiveConcat (
              if isList xs then
                map f xs
              else if isAttrs xs then
                mapAttrsToList f xs
              else
                throw "lib.foreach: First argument is of type ${builtins.typeOf xs}, but a list or attrset was expected."
            );

          findModules =
            with prev;
            dir:
            foreach (readDir dir) (
              name: value:
              let
                fullPath = dir + "/${name}";
                isNixModule = value == "regular" && hasSuffix ".nix" name && name != "default.nix";
                isDir = value == "directory";
                isDirModule = isDir && readDir fullPath ? "default.nix";
                module = nameValuePair (removeSuffix ".nix" name) (
                  if isNixModule || isDirModule then
                    fullPath
                  else if isDir then
                    findModules fullPath
                  else
                    { }
                );
              in
              optionalAttrs (isNotEmpty module.value) {
                "${module.name}" = module.value;
              }
            );
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
