{
  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
	      };
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
    geoclue2.enable = true;
    gnome.games.enable = false;
  };
  # Fix broken stuff
  services.avahi.enable = false;
}
