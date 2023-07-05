{ pkgs, lib, inputs, ... }:

{
  programs.firefox = {
    enable = true;
  };

  home = {
    sessionVariables.BROWSER = "firefox";
  #  persistence = {
      # Not persisting is safer
  #    "/persist/home/celso".directories = [ ".mozilla/firefox" ];
  #  };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
