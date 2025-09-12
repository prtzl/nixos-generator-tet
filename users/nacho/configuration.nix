{ pkgs, ... }:
{
  imports = [
    ../../profiles/home/zsh.nix
    ../../profiles/home/hyprland.nix
  ];
  home.stateVersion = "25.05"; # adjust to your nixos version

  programs.zsh.enable = true;
  programs.git.enable = true;
  home.packages = with pkgs; [ tmux ];
}
