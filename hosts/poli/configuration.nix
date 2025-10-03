{
  local,
  lib,
  pkgs,
  ...
}:

let
  linux_6_16 = pkgs.linux_6_16.override {
    argsOverride = rec {
      version = "6.16.2";
      modDirVersion = "${version}";
      src = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-t2Cm+nk9d0+9O3+gvqPv1cT1KU37mO8b1fbV98708G0=";
      };
    };
  };
  myKernel = pkgs.linuxPackagesFor linux_6_16;
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
    # kernelPackages = myKernel;
    kernelModules = [
      "nct6775" # nct6775: asrock board sensors
    ];
  };

  # Also installs v4l2loopback kernel module if needed (otherwise home config should be fine)
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };
}
