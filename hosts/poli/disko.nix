{
  disko.devices.disk = {
    main = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25221P801548";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            label = "boot";
            size = "1M";
            type = "EF02";
            priority = 0;
          };
          ESP = {
            label = "EFI";
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            label = "nixos";
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
            };
          };
        };
      };
    };

    # storage = {
    #   device = "/dev/disk/by-id/nvme-Lexar_SSD_NM790_4TB_QER497R000155P220";
    #   type = "disk";
    #   content = {
    #     type = "gpt"; # Optional if already formatted
    #     partitions = {
    #       data = {
    #         label = "storage";
    #         size = "100%";
    #         content = {
    #           type = "filesystem";
    #           format = "xfs";
    #           mountpoint = "/storage";
    #           mountOptions = [
    #             "defaults"
    #             "user"
    #             "rw"
    #             "exec"
    #           ];
    #         };
    #       };
    #     };
    #   };
    # };
  };

  # Aparrently since it's already formatted use it like this and it won't ever attempt to format it
  # even on a nixos-install or disko install. It will skip it
  disko.devices.nodev = {
    storage = {
      device = "/dev/disk/by-label/storage"; # or by-id
      fsType = "xfs";
      mountpoint = "/storage";
      mountOptions = [
        "defaults"
        "user"
        "rw"
        "exec"
      ];
    };
  };
}
