{
  local,
  lib,
  pkgs,
  ...
}:

let
  linux_6_16_8 = pkgs.linux_6_16.override {
    argsOverride = {
      version = "6.16.8";
      modDirVersion = "6.16.8";
      src = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.16.8.tar.xz";
        sha256 = "sha256-IxMRvXCE3DEplE0mu0O+b/g32oL7IQSmdwSuvKi/pp8";
      };
    };
  };
  myKernel = pkgs.linuxPackagesFor linux_6_16_8;
in
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
    kernelPackages = myKernel;
    kernelModules = [
      "nct6775" # nct6775: asrock board sensors
    ];
  };
}
