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

  name = "macho";
  uid = 1001;

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [
    "wheel"
    "dialout"
    "networkmanager"
    "adbusers"
  ];

  extraSpecialArgs = {
    machine = machineInfo;
  };
}
