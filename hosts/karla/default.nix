{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = {
    edition = "workstation";
    buildPlatform = "x86_64-linux";
    hostPlatform = "x86_64-linux";

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
        }
      ];
    };
  };

  modules =
    with (lib.findModules ../../users);
    [
      matej
    ]
    ++ [
      ./configuration.nix
      ./disko.nix
    ];

  specialArgs = {
    local = inputs;
    inherit lib;
  };
}
