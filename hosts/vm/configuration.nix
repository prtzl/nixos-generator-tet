{
  ...
}:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
    };
  };

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  boot = {
    initrd.kernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_blk"
      "virtio_net"
      "virtio_balloon"
      "virtio_rng"
      "sr_mod"
    ];
    extraModulePackages = [ ];
  };
}
