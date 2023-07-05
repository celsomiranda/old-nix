{ inputs, outputs, ... }:
{
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/cli
    ./features/pass
    ./features/emacs
  ];
}
