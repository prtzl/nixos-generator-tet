{
  lib,
  my,
  inputs,
}:

let
  hostDirs = builtins.filter (n: (builtins.readDir ./../hosts)."${n}" == "directory") (
    builtins.attrNames (builtins.readDir ./../hosts)
  );

  mkHost =
    name:
    import (./../hosts + "/${name}") {
      inherit lib my;
      inherit inputs;
    };
in
lib.genAttrs hostDirs mkHost
