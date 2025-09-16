{
  lib,
  pillow,
  ...
}:

{
  imports = with (lib.findModules ../../profiles/home); [
    base
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
