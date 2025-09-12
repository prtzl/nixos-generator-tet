{
  lib,
  ...
}:

with lib;
{
  findModules =
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
