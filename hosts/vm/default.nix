{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = {
    buildPlatform = "x86_64-linux";
    hostPlatform = "x86_64-linux";

    host = rec {
      name = "vm";
      hostname = name;
      interfaces = [ "enp1s0" ];
      disks = [ "/" ];
    };
  };

  modules =
    with (lib.findModules ../../users);
    [
      nacho
      macho
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
