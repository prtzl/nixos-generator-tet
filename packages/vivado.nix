{
  pkgs,
  ...
}:

# used installer FPGAs_AdaptiveSoCs_Unified_SDI_2026.1_0616_1700_Lin64.bin
let
  amdRoot = "/storage/projects/AMD_Xilinx_2026.1";

  vivadoRoot = "${amdRoot}/2026.1/Vivado";
  vitisRoot = "${amdRoot}/2026.1/Vitis";
  docnavRoot = "${amdRoot}/DocNav";

  amdFhs = pkgs.buildFHSEnv {
    name = "amd-xilinx-fhs";

    targetPkgs =
      pkgs: with pkgs; [
        # Basic Unix environment
        bash
        coreutils
        findutils
        gnugrep
        gawk
        gnused
        which
        git
        dpkg
        avahi

        # Installer / archives / networking
        curl
        wget
        unzip
        zip
        gzip
        bzip2
        xz
        gnutar

        # Runtime
        glib
        glibc
        zlib
        ncurses
        libxcrypt
        openssl
        libuuid
        expat

        # GUI
        gtk3
        pango
        cairo
        gdk-pixbuf
        atk
        fontconfig
        freetype
        libnotify

        # X11
        libx11
        libxcb
        libxcursor
        libxext
        libxfixes
        libxi
        libxinerama
        libxrandr
        libxrender
        libxt
        libxtst

        # Graphics
        libglvnd
        mesa
        pixman
        libpng

        # Hardware
        libusb1
        udev

        # Desktop/runtime
        dbus
        krb5
      ];

    multiPkgs =
      pkgs: with pkgs; [
        glib
        glibc
        zlib
        ncurses
        ncurses5
        libxcrypt
        libuuid
        libusb1
      ];

    runScript = "bash";
  };

  notifyMissing = name: path: ''
    echo "${name} was not found at:"
    echo "  ${path}"

    if command -v notify-send >/dev/null 2>&1; then
      notify-send "${name}" "${name} was not found at: ${path}"
    fi

    exit 1
  '';

  vivado = pkgs.writeShellScriptBin "vivado" ''
    set -e

    export VIVADO="${vivadoRoot}"
    export LD_LIBRARY_PATH="$VIVADO/lib/lnx64.o:/usr/lib64:/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    if [ ! -x "$VIVADO/bin/vivado" ]; then
      ${notifyMissing "Vivado" "${vivadoRoot}/bin/vivado"}
    fi

    exec ${amdFhs}/bin/amd-xilinx-fhs \
      "$VIVADO/bin/vivado" \
      "$@"
  '';

  vitis = pkgs.writeShellScriptBin "vitis" ''
    set -e

    export VITIS="${vitisRoot}"
    export LD_LIBRARY_PATH="$VITIS/lib/lnx64.o:/usr/lib64:/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    if [ ! -x "$VITIS/bin/vitis" ]; then
      ${notifyMissing "Vitis" "${vitisRoot}/bin/vitis"}
    fi

    exec ${amdFhs}/bin/amd-xilinx-fhs \
      "$VITIS/bin/vitis" \
      "$@"
  '';

  docnav = pkgs.writeShellScriptBin "docnav" ''
    set -e

    export DOCNAV="${docnavRoot}"
    export LD_LIBRARY_PATH="$DOCNAV/lib/lnx64.o:/usr/lib64:/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    if [ ! -x "$DOCNAV/docnav" ]; then
      ${notifyMissing "Documentation Navigator" "${docnavRoot}/docnav"}
    fi

    exec ${amdFhs}/bin/amd-xilinx-fhs \
      "$DOCNAV/docnav" \
      "$@"
  '';

  vivadoDesktop = pkgs.makeDesktopItem {
    name = "vivado-2026.1";
    desktopName = "Vivado 2026.1";
    comment = "AMD Vivado 2026.1";
    exec = "${vivado}/bin/vivado";
    icon = "${vivadoRoot}/doc/images/vivado_logo.png";
    terminal = false;
    categories = [
      "Development"
      "Electronics"
    ];
  };

  vitisDesktop = pkgs.makeDesktopItem {
    name = "vitis-2026.1";
    desktopName = "Vitis 2026.1";
    comment = "AMD Vitis 2026.1";
    exec = "${vitis}/bin/vitis";
    icon = "${vitisRoot}/doc/images/ide_icon.png";
    terminal = false;
    categories = [ "Development" ];
  };

  docnavDesktop = pkgs.makeDesktopItem {
    name = "documentation-navigator";
    desktopName = "Documentation Navigator";
    comment = "AMD Documentation Navigator";
    exec = "${docnav}/bin/docnav";
    icon = "${docnavRoot}/resources/doc_nav_application_48.png";
    terminal = false;
    categories = [ "Development" ];
  };
in
{
  inherit
    amdFhs
    vivado
    vitis
    docnav
    vivadoDesktop
    vitisDesktop
    docnavDesktop
    ;
}
