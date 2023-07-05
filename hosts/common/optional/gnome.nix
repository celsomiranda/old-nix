{pkgs, ...}: {
  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
      displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
        };
        autoLogin = {
          enable = true;
          user = "celso";
        };
      };
      layout = "pt";
      excludePackages = (with pkgs; [
        xterm
      ]);

    };
    geoclue2.enable = true;
    gnome.games.enable = false;
    # Fix broken stuff
    avahi.enable = false;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };

  programs.dconf.enable = true;

  # GNOME Extensions
  environment.systemPackages = (with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    just-perfection
  ]);

  # Remove uneeded packages
  environment.gnome.excludePackages = (with pkgs; [
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
}
