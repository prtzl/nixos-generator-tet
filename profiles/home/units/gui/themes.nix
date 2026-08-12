{
  pkgs,
  ...
}:

{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  gtk =
    let
      tooltipTimeout = 100;
      gtkExtraConfig = {
        gtk-tooltip-timeout = tooltipTimeout;
      };
    in
    {
      enable = true;
      theme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
      gtk2.extraConfig = ''
        gtk-tooltip-timeout = ${builtins.toString tooltipTimeout}
      '';
      gtk3.extraConfig = gtkExtraConfig;
      gtk4.extraConfig = gtkExtraConfig;
    };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
