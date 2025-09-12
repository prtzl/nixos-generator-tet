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

    # Inline minimal system config
    (
      { pkgs, ... }:
      {
        imports = [ ];

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelPackages = pkgs.linuxPackages_latest;

        networking.hostName = "minimal";
        networking.useDHCP = true;

        time.timeZone = "UTC";

        services.openssh.enable = true;

        environment.systemPackages = with pkgs; [
          vim
          git
          curl
        ];

        # ❗ Required: root filesystem definition
        fileSystems."/" = {
          device = "/dev/sda2";
          fsType = "ext4"; # or btrfs/xfs/etc.
        };

        # Optional: boot partition if using EFI
        fileSystems."/boot" = {
          device = "/dev/sda1";
          fsType = "vfat";
        };

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
    )
  ];

  specialArgs = {
    local = inputs;
    inherit lib my;
  };
}
