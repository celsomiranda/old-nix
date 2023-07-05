{ inputs, outputs, ... }:
{
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/cli
    ./features/pass
    ./features/emacs
  ];

  colorscheme = inputs.nix-colors.colorSchemes.atelier-heath;

  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
  }];
}
