{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.celso.de;
  xserver = (
    config.celso.machine.role != "server" &&
    config.celso.machine.flavor != "wsl"
  );

in
{
  options = {
    celso.machine.highDPI = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Optimize for high DPI outputs (4k)";
    };
    celso.de.variant = mkOption {
      type = types.enum [ "none" "gnome" "plasma" "wm" "xfce" ];
      default = if xserver then "wm" else "none";
      description = "Desktop Environment flavor";
    };
  };

  config = mkMerge [
    (mkIf (cfg.variant != "none") {
      services.xserver.enable = true;
      services.xserver.layout = "pt";
      services.xserver.xkbVariant = "alt-intl-unicode";

      # Enable touchpad support
      services.xserver.libinput.enable = true;
      services.xserver.libinput.touchpad.naturalScrolling = true;

      # LightDM Background image
      # services.xserver.displayManager.lightdm.background = "${pkgs.celso.wallpapers}/alien-moon-nature.jpg";

      # Disable xterm session
      services.xserver.desktopManager.xterm.enable = false;
    })
    # WM
    (mkIf (cfg.variant == "wm") {
      # Home manager xsession
      services.xserver.desktopManager.session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }];

      # Session - gnome-keyring - https://github.com/jluttine/NiDE/blob/master/src/keyring.nix
      programs.dconf.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.xdm.enableGnomeKeyring = true;
    })
    # Gnome
    (mkIf (cfg.variant == "gnome") {
      services.xserver.displayManager.gdm.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
    })
    # KDE Plasma
    (mkIf (cfg.variant == "plasma") {
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;
    })
    # XFCE
    (mkIf (cfg.variant == "xfce") {
      # Home manager xsession
      services.xserver.windowManager.session = [{
        name = "home-manager";
        start = ''
          $HOME/.hm-xsession
        '';
      }];
      services.xserver.desktopManager = {
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
    })
  ];
}