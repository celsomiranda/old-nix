{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.celso = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/celso/ssh.pub) ];
    passwordFile = "/persist/passwords/celso";
    packages = [ pkgs.home-manager ];
  };


  home-manager.users.celso = import ../../../../home/celso/${config.networking.hostName}.nix;
  services.geoclue2.enable = true;
}
