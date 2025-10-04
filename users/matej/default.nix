{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
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
    "libvirtd"
    "networkmanager"
    "openrazer"
    "plugdev"
    "usb"
    "video"
    "wheel"
    "kakica"
  ];

  extraSpecialArgs = {
  };
}
