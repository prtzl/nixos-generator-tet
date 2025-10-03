{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = lib.makePillowArgs {
    edition = "virtual";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "vm";
      interfaces = [ "enp1s0" ];
      disks = [ "/" ];
    };
  };

  modules =
    (lib.findModulesList ./.)
    ++ (with (lib.findModules ../../users); [
      macho
      nacho
    ]);

  specialArgs = {
    local = inputs;
  };
}
