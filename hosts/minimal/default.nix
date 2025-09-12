{
  inputs,
  lib,
  my,
}:

let
  machineInfo = rec {
    name = "minimal";
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

  modules = [
    ./configuration.nix
    ../../users/nacho
    ../../users/macho
  ];

  specialArgs = {
    local = inputs;
    inherit lib my;
    inherit machineInfo;
  };
}
