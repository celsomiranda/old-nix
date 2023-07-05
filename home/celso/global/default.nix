{ inputs, lib, pkgs, config, outputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../features/cli
    ../features/emacs
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Celso Miranda";
      userEmail = "769237+celsomiranda@users.noreply.github.com";
    };
  };

  home = {
    username = lib.mkDefault "celso";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    # FIXME
    # ADD DOOM EMACS
    sessionPath = [ "$HOME/.local/bin" "$HOME/.config/emacs/bin" ];

    persistence = {
      "/persist/home/celso" = {
        allowOther = true;
        directories = [
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Projects"
          "Videos"

          ".config/BraveSoftware"
          ".config/emacs"
          ".config/doom"
          ".config/keepassxc"
          ".config/libreoffice"
          ".local/bin"
          ".local/lib/node_modules"
          ".local/share/doom"
          ".local/share/fonts"
        ];
        files = [
          ".npmrc"
          ".zsh_history"
          ".ansible.cfg"
        ];
      };
    };
  };
}
