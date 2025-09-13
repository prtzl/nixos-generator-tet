{
  lib,
  inputs,
}:

let
  hostDirs = builtins.filter (n: (builtins.readDir ./../hosts)."${n}" == "directory") (
    builtins.attrNames (builtins.readDir ./../hosts)
  );

  mkHost =
    let
      nixos-hardware = inputs.nixos-hardware.nixosModules;
    in
    name:
    import (./../hosts + "/${name}") {
      inherit lib inputs nixos-hardware;
    };
in
lib.genAttrs hostDirs mkHost
