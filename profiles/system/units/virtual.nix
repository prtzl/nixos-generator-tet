{
  pkgs,
  ...
}:

{
  virtualisation = {
    containers.enable = true; # some common stuff?
    docker.enable = true;
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libguestfs
    spice-gtk
    spice-vdagent
    virt-manager
    virt-viewer
    docker-compose
    podman-compose
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "x86_64-windows"
  ];
}
