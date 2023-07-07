{
  imports = [ ../common ];

  services.xserver = {
    # GDM
    displayManager= {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "cjcma";
      };
    };

    # Gnome
    desktopManager.gnome.enable = true;
  };

  # Remove extra packages
  environment = {
    gnome.excludePackages = (with pkgs; [
        gnome-tour
        epiphany
    ]) ++ (with pkgs.gnome; [
      geary
      gnome-music
      totem
      tali
      iagno
      hitori
      atomix
    ]);
    systemPackages = with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
    ];
  };
}
