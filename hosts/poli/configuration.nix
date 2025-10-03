{
  local,
  lib,
  ...
}:

{
  imports = [
    local.nixos-hardware.nixosModules.common-cpu-amd
    local.nixos-hardware.nixosModules.common-gpu-intel
    local.nixos-hardware.nixosModules.common-pc
    local.nixos-hardware.nixosModules.common-pc-ssd
  ]
  ++ (with (lib.findModules ../../profiles/system/units); [
    steam
  ]);

  boot = {
    kernelModules = [
      "nct6775" # nct6775: asrock board sensors
    ];
  };
}
