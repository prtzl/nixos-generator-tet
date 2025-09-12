{
  lib,
}:

dir:
let
  entries = builtins.readDir dir;

  modules = lib.mapAttrs' (
    name: type:
    let
      fullPath = dir + "/${name}";
      isNixFile = type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix";

      isDir = type == "directory";
      isDirModule = isDir && (builtins.readDir fullPath ? "default.nix");

      cleanName = lib.removeSuffix ".nix" name;

      value =
        if isNixFile || isDirModule then
          fullPath
        else if isDir then
          (import ./findModules.nix { inherit lib; }) fullPath
        else
          { };
    in
    lib.nameValuePair cleanName value
  ) entries;

in
lib.filterAttrs (_: v: v != { }) modules
