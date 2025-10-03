{
  inputs,
  lib,
  ...
}:

lib.pillowSystem {
  pillow = lib.makePillowArgs {
    edition = "workstation";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "karla";
      interfaces = [
        "wlp61s0"
        "enp0s31f6"
      ];
      disks = [ "/" ];
      temp_probes = [
        {
          path = "/dev/cpu_temp";
          icon = "";
        }
      ];
    };
  };

  modules =
    (lib.findModulesList ./.)
    ++ (with (lib.findModules ../../users); [
      matej
    ]);

  specialArgs = {
    local = inputs;
  };
}
