{ lib, pkgs, ... }:

{
  imports = [
    ../../profiles/system/fonts.nix
    ../../profiles/system/hyprland.nix
    ../../profiles/system/pipewire.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "minimal";
  networking.useDHCP = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
  ];

  #

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d345cdce-53f7-4474-b546-a7141106fa1b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/29DC-059E";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/3205bd4b-d777-40d8-a1f6-5c13ed6ffdf5"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # ❗ Required: root filesystem definition
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/PUT-YOUR-UUID-HERE";
  #   fsType = "ext4"; # or btrfs/xfs/etc.
  # };
  #
  # # Optional: boot partition if using EFI
  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/PUT-YOUR-BOOT-UUID-HERE";
  #   fsType = "vfat";
  # };

  # ❗ Required: match your NixOS version
  system.stateVersion = "25.05";
}
