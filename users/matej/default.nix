{
  my,
  pillow,
  machineInfo,
  ...
}:

my.mkUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "matej";
  uid = 1000;

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [
    "adbusers"
    "audio"
    "dialout"
    "docker"
    "kvm"
    "libvirtd"
    "networkmanager"
    "openrazer"
    "plugdev"
    "podman"
    "usb"
    "video"
    "wheel"
  ];

  extraSpecialArgs = {
    machine = machineInfo;
  };
}
