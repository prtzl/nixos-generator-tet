{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "nacho";
  uid = 1000;

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [
    "wheel"
    "dialout"
    "networkmanager"
    "adbusers"
  ];

  extraSpecialArgs = {
  };
}
