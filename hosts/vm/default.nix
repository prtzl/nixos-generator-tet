{
  inputs,
  lib,
  nixos-hardware,
}:

let
  machineInfo = rec {
    name = "vm";
    hostname = name;
    interfaces = [ "enp1s0" ];
    disks = [ "/" ];
  };
in
lib.pillowSystem {
  pillow = {
    edition = "workstation";
    buildPlatform = "x86_64-linux"; # where you build it
    hostPlatform = "x86_64-linux"; # target system arch
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
    inherit machineInfo;
  };
}
