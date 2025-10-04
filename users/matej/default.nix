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

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [
    "usb"
  ];

  extraSpecialArgs = {
  };
}
