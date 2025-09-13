{ lib }:

with lib;
with builtins;
rec {
  not = x: !x;
  isEmpty = x: x == null || x == "" || x == [ ] || x == { };
  isNotEmpty = x: not (isEmpty x);
  recursiveConcat = foldr recursiveUpdate { };

  foreach =
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
