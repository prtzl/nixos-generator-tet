{
  lib,
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    difftastic.enable = true;
    extraConfig = {
      core.init.defaultBranch = lib.mkDefault "master";
      log.date = lib.mkDefault "iso";
      # idea is that dir is owned by root but
      # maintainers are in group that has access
      # Git doesn't like this, so I'm placing this here
      safe.directory = "/etc/nixos";
    };
  };
}
