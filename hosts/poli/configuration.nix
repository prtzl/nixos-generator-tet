{
  lib,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.common-cpu-amd
    nixos-hardware.common-gpu-intel
    nixos-hardware.common-pc
    nixos-hardware.common-pc-ssd
  ]
  ++ (with (lib.findModules ../../profiles/system); [
    base
    steam
  ]);

  boot = {
    kernelModules = [
      "nct6775" # nct6775: asrock board sensors
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
}
