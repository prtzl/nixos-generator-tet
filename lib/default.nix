{
  inputs,
  externalModules ? [ ],
  version,
}:

inputs.nixpkgs.lib.extend (
  final: prev: {

    inherit (import ./utils.nix { lib = prev; }) findModules;

    inherit
      (import ./pillow.nix {
        lib = final;
        inherit
          inputs
          externalModules
          version
          ;
      })
      pillowSystem
      pillowUser
      ;

    collectHosts = import ./collect-hosts.nix {
      lib = final;
      inputs = inputs;
    };
  }
)
