{
  local,
  pkgs,
  pillow,
  ...
}:

let
  mkFree =
    drv:
    drv.overrideAttrs (attrs: {
      meta = attrs.meta // {
        license = "";
      };
    });
  # jlink = mkFree local.jlink-pack.defaultPackage."${pillow.hostPlatform}";
in
{
  environment.systemPackages = with pkgs; [
    # Jlink and stlink - are here to add udev rules. No way around this.
    # However this also adds their executables, which could be on a project-base.
    # ... But we still need rules on system config, so we can cry about it.
    # Have project-specific jlink but make sure system installed is up-to-date
    # so that your new shiny jlink is supported. Even better, just use this package as well, hehe.
    # jlink
    lm_sensors
    stlink
    tio
  ];

  services.udev = {
    extraRules = ''
      # Add all USB devices to usb group -> don't forget with your user
      KERNEL=="*", SUBSYSTEMS=="usb", MODE="0664", GROUP="usb"

      # RS232 devucesm yee
      SUBSYSTEMS=="usb", KERNEL=="ttyUSB[0-9]*", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", SYMLINK+="sensors/ftdi_%s{serial}", GROUP="dialout"

      # Somehow added jlink file to udev does not get picked up :/
    '';
    # ${builtins.readFile "${jlink}/lib/udev/rules.d/99-jlink.rules"}
  };
}
