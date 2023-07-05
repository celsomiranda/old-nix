{ config, lib, inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];
  networking.networkmanager.enable = true;
  environment.persistence = {
    "/persist".directories = [
      "/etc/NetworkManager"
      "/var/lib/NetworkManager"
    ];
  };

}
