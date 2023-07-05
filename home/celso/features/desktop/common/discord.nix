{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ discord ];

#  home.persistence = {
#    "/persist/home/celso".directories = [ ".config/discord" ];
#  };
}
