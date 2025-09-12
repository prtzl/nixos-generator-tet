{
  pkgs,
  ...
}:

{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "FiraCode Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
    fontDir.enable = true;
    packages = with pkgs; [
      fira
      fira-code
      fira-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      unstable.corefonts
    ];
  };
}
