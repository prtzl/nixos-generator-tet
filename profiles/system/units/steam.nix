{
  lib,
  pkgs,
  ...
}:

let
  pkgs-steam = pkgs;
in
{
  # Allow steam specifically
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "digilent.adept.runtime_2.30.1_amd64.deb"
    ];

  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs-steam; [ proton-ge-bin ];
    gamescopeSession.enable = true;
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    package = pkgs-steam.steam;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  programs.gamemode = {
    enable = true;
  };

  programs.gamescope = {
    enable = true;
    package = pkgs-steam.gamescope;
    capSysNice = true;
  };

  security.rtkit = {
    enable = true;
    package = pkgs-steam.rtkit;
  };

  # environment.sessionVariables = {
  #   MESA_LOADER_DRIVER_OVERRIDE = "iris";
  #   ANV_ENABLE_PIPELINE_CACHE = "1";
  #   VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
  # };
}
