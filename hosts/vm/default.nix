{
  inputs,
  lib,
  ...
}:

lib.pillowSystem rec {
  pillow = lib.makePillowArgs {
    edition = "virtual";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "vm";
      interfaces = [ "enp1s0" ];
      disks = [ "/" ];
    };

    settings.hyprland = {
      monitor = [
        ",1920x1080@60,auto,1"
      ];
    };
  };

  modules = (lib.findModulesList ./.) ++ [
    (import ../../users/macho {
      inherit lib pillow;
    })
    (import ../../users/nacho {
      inherit lib pillow;
    })
  ];

  specialArgs = {
  };
}
