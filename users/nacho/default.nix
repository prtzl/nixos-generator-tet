{
  lib,
  my,
  pkgs,
  pillow,
  ...
}:

my.mkUser pillow {
  imports = [
    (
      { ... }:
      {
        home.stateVersion = "25.05"; # adjust to your nixos version

        programs.zsh.enable = true;
        programs.git.enable = true;
	home.packages = with pkgs; [ tmux ];
      }
    )
  ];

  name = "nacho";
  uid = 1000;

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [ "wheel" ]; # sudo
}
