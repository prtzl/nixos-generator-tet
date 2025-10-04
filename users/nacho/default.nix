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
  privileged = false;

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [ ];

  extraSpecialArgs = {
  };
}
