# This file contains an ephemeral btrfs root configuration
# TODO: perhaps partition using disko in the future
{ lib, config, ... }:
let
  hostname = config.networking.hostName;
in
{
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=3G" "mode=755" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" "compress=zstd" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
  };
}
