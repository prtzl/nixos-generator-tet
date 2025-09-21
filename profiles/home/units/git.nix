{
  lib,
  ...
}:

{
  programs.git = {
    enable = true;
    difftastic.enable = true;
    extraConfig = {
      log.date = lib.mkDefault "iso";
      core.init.defaultBranch = lib.mkDefault "master";
    };
  };
}
