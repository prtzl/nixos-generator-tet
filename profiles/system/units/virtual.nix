{
  lib,
  pillow,
  pkgs,
  ...
}:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        ovmf = lib.mkMerge [
          {
            enable = true;
          }
          (lib.optionalAttrs (pillow.hostPlatform == "x86_64") {
            packages = [ pkgs.OVMFFull.fd ];
          })
        ];
        runAsRoot = false;
      };
    };
    spiceUSBRedirection.enable = true;
    containers.enable = true; # some common stuff?
    docker.enable = true;
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    docker-compose
    fuse-overlayfs
    libguestfs
    podman-compose
    podman-tui # status of containers in the terminal
    spice-gtk
    spice-vdagent
    swtpm
    virt-manager
    virt-viewer
  ];

  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "x86_64-windows"
    ];
    kernelModules = [
      "kvm-amd"
      "kvm-intel"
    ];
  };
}
