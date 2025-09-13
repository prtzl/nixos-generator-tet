{
  inputs,
  lib,
  my,
}:

let
  # findModules = import ../../lib/findModules.nix { inherit lib; };
  inherit (lib) findModules;
  machineInfo = rec {
    name = "vm";
    hostname = name;
    interfaces = [ "enp1s0" ];
    disks = [ "/" ];
  };
in
my.mkSystem {
  pillow = {
    edition = "workstation";
    buildPlatform = "x86_64-linux"; # where you build it
    hostPlatform = "x86_64-linux"; # target system arch
  };

  modules =
    with (findModules ../../users);
    [
      nacho
      macho
    ]
    ++ [
      ./configuration.nix
    ];

  specialArgs = {
    local = inputs;
    inherit lib my;
    inherit machineInfo;
  };
}
