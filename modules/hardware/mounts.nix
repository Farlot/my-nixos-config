{
  fileSystems."/mnt/stuff" = {
    device = "/dev/disk/by-uuid/8198a4fe-fc70-4045-b177-c3e98eacd5cd";
    fsType = "ext4";
  };

  fileSystems."/mnt/nvme0" = {
    device = "/dev/disk/by-uuid/48423cb3-f93f-4db0-8083-9f7cf766a67b";
    fsType = "ext4";
  };
}
