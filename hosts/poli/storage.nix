{
  fileSystems."/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "xfs";
    options = [
      "defaults"
      "user"
      "rw"
      "exec"
    ];
  };
}
