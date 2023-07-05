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
}
