{
  pkgs,
  lib,
  pillow,
  ...
}:
{
  imports = [
    ../../profiles/home/base.nix
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
