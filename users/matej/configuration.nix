{
  pkgs,
  lib,
  pillow,
  ...
}:

let
  findModules = import ../../lib/findModules.nix { inherit lib; };
in
{
  imports = with (findModules ../../profiles/home); [
    base
  ];

  home.packages =
    with pkgs;
    [ ]
    ++ lib.optionals (pillow.edition == "workstation") [
      # Dev
      arduino
      unstable.drawio # unstable is free

      # Content creation
      audacity
      gimp
      obs-studio
    ];

  programs.git = {
    userName = "prtzl";
    userEmail = "matej.blagsic@protonmail.com";
    extraConfig = {
      core = {
        init.defaultBranch = "master";
      };
    };
  };
}
