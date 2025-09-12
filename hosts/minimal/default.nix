{
  inputs,
  lib,
  my,
  ...
}:

my.mkSystem {
  pillow = {
    edition = "server";
    buildPlatform = "x86_64-linux"; # where you build it
    hostPlatform = "x86_64-linux"; # target system arch
  };

  modules = [
    ../../users/nacho
    inputs.nvimnix.nixosModules."x86_64-linux".nvimnix
    ./configuration.nix
  ];

  specialArgs = {
    local = inputs;
    inherit lib my;
  };
}
