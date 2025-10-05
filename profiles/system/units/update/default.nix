{
  pkgs,
  ...
}:

let
  updateScript = pkgs.writeShellScript "update.sh" "${builtins.readFile ./update.sh}";
  makeUpdate =
    kind:
    pkgs.writeShellApplication {
      name = "${kind}-update";
      runtimeInputs = [ pkgs.nvd ];
      text = ''
        ${updateScript} ${kind} "$@"
      '';
    };
in
{
  environment.systemPackages = [ (makeUpdate "nixos") ];
}
