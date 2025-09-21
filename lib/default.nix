{
  inputs,
  externalModules ? [ ],
  version,
}:

inputs.nixpkgs.lib.extend (
  final: prev:
  let
    pillow = import ./pillow.nix {
      lib = final;
      inherit
        externalModules
        version
        inputs
        ;
    };
    collectHosts = import ./collect-hosts.nix {
      lib = final;
      inherit inputs;
    };
    utils = import ./utils.nix { lib = final; };
  in
  pillow // { inherit collectHosts; } // utils
)
