{
  pillow,
  pkgs,
  pkgs-unfree,
  version,
  ...
}:

{
  home.stateVersion = version;
  home.preferXdgDirectories = true;

  home.packages =
    let
      # One on unstable version (6.11.6.183) has issue downloading the resource. Go for newest.
      _my-enpass =
        let
          baseUrl = "https://apt.enpass.io";
          path = "pool/main/e/enpass/enpass_6.11.13.1957_amd64.deb";
          url = "${baseUrl}/${path}";
          version = "6.11.13.1957";
          sha256 = "2d8c90643851591aff41057b380a7e87bb839bf5c5aa0ca1456144e9996c902a";
        in
        pkgs.enpass.overrideAttrs (old: {
          inherit version;
          src = builtins.fetchurl {
            inherit sha256 url;
          };
        });
    in
    with pkgs;
    [
      duf # modern df with colors :D
      dysk # disk usage
      ffmpeg-full # yes
    ]
    ++ lib.optionals (pillow.hasGUI) [
      # Web
      ungoogled-chromium
      transmission_4-gtk

      # Utility
      pkgs-unfree.enpass # my-enpass
      qalculate-gtk # calculator fyi
      gnome-disk-utility

      # Communication
      signal-desktop

      # media/creation
      audacity
      libreoffice
      gimp
      inkscape

      # media viewers
      loupe # image viewer
      evince # pdf viewer
      kdePackages.okular # another pdf viewer
      kdePackages.gwenview

      # file explorer
      thunar
      thunar-archive-plugin
      tumbler
    ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Video
      "video/mp4" = [ "celluloid.desktop" ];
      "video/x-matroska" = [ "celluloid.desktop" ];
      "video/webm" = [ "celluloid.desktop" ];

      # Audio
      "audio/mpeg" = [ "celluloid.desktop" ];
      "audio/flac" = [ "celluloid.desktop" ];
      "audio/wav" = [ "celluloid.desktop" ];

      # Images
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];

      # PDF
      # "application/pdf" = [ "org.kde.okular.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];

      # Text
      "text/plain" = [ "nvim.desktop" ];
    };

    associations.added = {
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
  };
}
