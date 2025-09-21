{
  pkgs,
  lib,
  pillow,
  ...
}:
{
  imports = with (lib.findModules ../../profiles/home); [
    base
  ];
}
