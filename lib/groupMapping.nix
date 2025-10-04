{
  config,
  lib,
  ...
}:

let
  # Groups safe for all users (applied to everyone if enabled in config)
  baseGroups = [
    "audio"
    "dialout"
    "lp"
    "openrazer"
    "plugdev"
    "scanner"
    "usb"
    "video"
  ];

  # Groups only allowed for trusted/privileged users
  privilegedGroups = [
    "docker"
    "kvm"
    "libvirtd"
    "networkmanager"
    "podman"
    "wheel"
    "wireshark"
  ];

  # Config option => List of group names it enables
  dynamicGroupMapping = {
    "hardware.graphics.enable" = [ "video" ];
    "hardware.openrazer.enable" = [ "openrazer" ];
    "hardware.sane.enable" = [ "scanner" ];
    "networking.networkmanager.enable" = [ "networkmanager" ];
    "programs.wireshark.enable" = [ "wireshark" ];
    "services.printing.enable" = [ "lp" ];
    "services.pulseaudio.enable" = [ "audio" ];
    "services.udev.packages" = [ "plugdev" ];
    "virtualisation.docker.enable" = [ "docker" ];
    "virtualisation.libvirtd.enable" = [ "libvirtd" ];
    "virtualisation.podman.enable" = [ "podman" ];
  };

  # check if 'config' option "a.b.c"->"config.a.b.c" (c==enable) is true safely
  isConfigEnabled =
    path:
    let
      parts = lib.splitString "." path;
      value = lib.getAttrFromPath parts config;
    in
    value != null && value != false && value != [ ] && value != { };

  # Creates list of all enabled dynamic groups
  dynamicGroups = lib.unique (
    lib.concatLists (
      lib.mapAttrsToList (
        configOption: groups: if isConfigEnabled configOption then groups else [ ]
      ) dynamicGroupMapping
    )
  );

in
{
  inherit
    baseGroups
    privilegedGroups
    dynamicGroups
    ;
}
