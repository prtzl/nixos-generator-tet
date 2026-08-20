{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  _kernels = rec {
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
    mykernel = pkgs.linuxPackagesFor linux_6_16;
  };

  xilinx = pkgs.callPackage ../../packages/vivado.nix { };
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
    supportedFilesystems = [ "ntfs" ];
  };

  hardware = {
    openrazer.enable = true;
    graphics = {
      enable = true;
      package = pkgs.mesa;
      package32 = pkgs.pkgsi686Linux.mesa;
    };
    graphics.extraPackages = with pkgs; [
      vulkan-validation-layers
    ];
  };

  services = {
    hardware = {
      openrgb = {
        enable = true;
        motherboard = "amd";
      };
    };
    openssh.enable = true;
    jlink.enable = true;
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  programs = {
    obs-studio.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  environment.systemPackages =
    with pkgs;
    with xilinx;
    [
      arduino
      nvtopPackages.intel
      rsync
      tauon

      vivado
      vitis
      docnav
      vivadoDesktop
      vitisDesktop
      docnavDesktop
    ];
}
