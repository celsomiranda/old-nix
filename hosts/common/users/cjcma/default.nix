{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.cjcma = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "minecraft"
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/cjcma/ssh.pub) ];
    passwordFile = config.sops.secrets.cjcma-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.cjcma-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.cjcma = import ../../../../home/cjcma/${config.networking.hostName}.nix;

}
