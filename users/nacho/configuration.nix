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

  home.packages =
    with pkgs;
    [ ]
    ++ lib.optionals (pillow.edition == "workstation") [
    ];

}
