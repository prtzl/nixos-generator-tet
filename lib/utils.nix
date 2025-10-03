{ lib }:

with lib;
with builtins;
rec {
  not = x: !x;
  isEmpty = x: x == null || x == "" || x == [ ] || x == { };
  isNotEmpty = x: not (isEmpty x);
  recursiveConcat = foldr recursiveUpdate { };
  pipef = flip pipe;
  append = x: xs: xs ++ [ x ];

  requiredAttr =
    name: set:
    if hasAttr name set then getAttr name set else throw "Missing required config: pillow.${name}!";

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

  flattenAttrs =
    cond:
    pipef [
      (mapAttrsToList (name: value: nameValuePair (singleton name) value))
      (foldr (
        p@{ name, value }:
        acc:
        if isAttrs value && cond value then
          acc
          ++ pipe value [
            (flattenAttrs cond)
            (map (mapName (n: name ++ n)))
          ]
        else
          append p acc
      ) [ ])
    ];

  # Find all .nix files (not .nix) in a directory recurse in
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

  # Same as `findModules`, but returns all the modules found in a list.
  findModulesList = pipef [
    findModules
    (flattenAttrs (const true))
    (map (x: x.value))
  ];
}
