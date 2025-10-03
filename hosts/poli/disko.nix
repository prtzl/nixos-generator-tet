{
  disko.devices = {
    disk = {
      my-disk = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25221P801548";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
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
            fastStorage = {
              label = "storage";
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/storage";
              };
            };
          };
        };
      };
    };
  };
}
