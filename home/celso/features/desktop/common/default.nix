{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./discord.nix
    ./firefox.nix
    ./font.nix
  ];
}
