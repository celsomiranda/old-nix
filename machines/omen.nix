#
# `map` is a Windows 11 machine and this configuration is for WSL on that host.
#
# Graphical apps are supported, but unfortunately not GL, see:
#
#   https://github.com/guibou/nixGL/issues/69
#

{ config, pkgs, ... }: {
  celso.machine = {
    role = "desktop";
    flavor = "wsl";
    highDPI = false;
    user = {
      name = "celso";

      # This maps to the `users.users.celso` NixOS config
      config = {
        isNormalUser = true;
        initialPassword = "nixos";
        extraGroups = [ "wheel" "networkmanager" ];
        openssh.authorizedKeys.keys = [ ];
      };

      # This maps to the `home-manager.users.celso` NixOS (HM module) config
      profile = {
        imports = [
          ../home-manager
        ];

        config = {
          home.packages = with pkgs; [
            mosh
          ];

          home.sessionVariables = {
            EDITOR = "et";
            XDG_RUNTIME_DIR = "/run/user/$(id -u)";
          };

          programs = {
            # SSH agent
            keychain = {
              enable = true;
              keys = [ "id_ed25519" ];
            };

            ssh = {
              enable = true;
              includes = [
                config.age.secrets.ssh.path
              ];
            };
          };

          celso.dev = {
            docs.enable = true;
            nodejs.enable = true;
          };

          services = { };
        };
      };
    };
  };

  age.secrets.ssh = {
    file = ./../secrets/ssh.age;
    owner = config.celso.machine.user.name;
  };

  documentation.nixos.enable = true;
}
