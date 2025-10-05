{
  config,
  pkgs,
  lib,
  ...
}:

with builtins;
with lib;
let
  update = pkgs.writeShellApplication {
    name = "update";
    runtimeInputs = with pkgs; [ nvd ];
    text = builtins.readFile ./update.sh;
  };
in
{
  environment.systemPackages = [ update ];
}
