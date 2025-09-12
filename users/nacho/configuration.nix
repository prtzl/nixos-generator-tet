{ ... }:
{
  imports = [
    ../../profiles/home/alacritty.nix
    ../../profiles/home/hyprland.nix
    ../../profiles/home/themes.nix
    ../../profiles/home/tmux.nix
    ../../profiles/home/waybar.nix
    ../../profiles/home/zsh.nix
  ];
  home.stateVersion = "25.05"; # adjust to your nixos version

  programs.git.enable = true;
}
