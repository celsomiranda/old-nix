{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./qt.nix
  ];

  # Default X11 stuff
  services.xserver = {
    enable = true;
    layout = "pt";
    excludePackages = (with pkgs; [ xterm ]);
  };
}
