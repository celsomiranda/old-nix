{ inputs, ... }: {
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/productivity
    ./features/pass
    ./features/music
  ];
}
