{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  linux_6_16 = pkgs.linux_6_16.override {
    argsOverride = rec {
      version = "6.16.8";
      modDirVersion = "${version}";
      src = pkgs.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "sha256-IxMRvXCE3DEplE0mu0O+b/g32oL7IQSmdwSuvKi/pp8=";
      };
    };
  };
  myKernel = pkgs.linuxPackagesFor linux_6_16;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
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

  hardware = {
    openrazer.enable = true;
  };

  programs = {
    obs-studio = {
      enable = true;
      # Also installs v4l2loopback kernel module if needed (otherwise home config should be fine)
      enableVirtualCamera = true;
    };
    wireshark.enable = true;
  };
}
