{
  inputs,
  externalModules ? [ ],
  version,
}:

inputs.nixpkgs.lib.extend (
  final: prev: {

    inherit (import ./utils.nix { lib = prev; }) findModules;

    my = import ./my-system.nix {
      lib = final;
      inherit (inputs) nixpkgs home-manager;
      inherit
        externalModules
        version
        ;
    };

    collectHosts = import ./collect-hosts.nix {
      lib = final;
      inherit (final) my;
      inputs = inputs;
    };
  }
)
