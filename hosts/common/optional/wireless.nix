{ config, lib, inputs, ... }:
{
  networking.networkmanager.enable = true;
  environment.persistence = {
    "/persist".directories = [
      "/etc/NetworkManager"
      "/var/lib/NetworkManager"
    ];
  };

}
