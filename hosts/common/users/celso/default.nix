{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.celso = {
    isNormalUser = true;
    shell = pkgs.zsh;
    group = "users";
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "networkmanager"
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNEjRa9V1RmX55DQp/kfUd4mG5W9FTLfZR/40uDUYxm omen-laptop" ];
    passwordFile = "/persist/passwords/celso";
    packages = [ pkgs.home-manager ];
  };


  home-manager.users.celso = import ../../../../home/celso/${config.networking.hostName}.nix;
  services.geoclue2.enable = true;
}
