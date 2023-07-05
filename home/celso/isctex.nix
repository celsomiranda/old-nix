{ inputs, ... }: {
  imports = [
    ./global
    ./features/desktop/gnome
    ./features/productivity
    ./features/pass
    ./features/music
  ];

  colorscheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato;

  #  ------  ------
  # | DP-2 || DP-1 |
  #  ------  ------
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1080;
      x = 1920;
      workspace = "1";
    }
    {
      name = "DP-2";
      width = 0;
      height = 1080;
      noBar = true;
      x = 1920;
      workspace = "2";
    }
  ];
}
