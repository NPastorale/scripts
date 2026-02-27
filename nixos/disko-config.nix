{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          # Recommended options for a modern ZFS pool
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
          acltype = "posixacl";
          xattr = "sa";
          atime = "off";
        };
        # Options for the entire pool creation
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          # The root dataset (/)
          # We don't encrypt the root according to user preference
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
          };

          # The home dataset (/home)
          # We encrypt this dataset with native ZFS encryption. It demands a passphrase.
          # The keyformat is passphrase, meaning during Disko setup it will prompt.
          # We set mountpoint=legacy so NixOS fstab handles mounting.
          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              mountpoint = "legacy";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
            };
          };
        };
      };
    };
  };
}
