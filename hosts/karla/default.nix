{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = lib.makePillowArgs {
    edition = "workstation";
    buildPlatform = "x86_64-linux";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = rec {
      name = "karla";
      hostname = name;
      interfaces = [
        "wlp61s0"
        "enp0s31f6"
      ];
      disks = [ "/" ];
      temp_probes = [
        {
          path = "/dev/cpu_temp";
          icon = "*";
        }
      ];
    };
  };

  modules =
    (with (lib.findModules ../../users); [
      matej
    ])
    ++ [
      ./configuration.nix
      ./disko.nix
      ../../profiles/system
    ];

  specialArgs = {
    local = inputs;
  };
}
