{
  lib,
  pillow,
  ...
}:

{
  programs.git = {
    enable = lib.mkDefault true;
    difftastic.enable = lib.mkDefault true;
    extraConfig.log.date = lib.mkDefault "iso";
  }
  // (
    if (pillow ? personal && pillow.personal == true) then
      {
        userName = "prtzl";
        userEmail = "matej.blagsic@protonmail.com";
        extraConfig = {
          core = {
            init.defaultBranch = "master";
          };
        };
      }
    else
      { }
  );
}
