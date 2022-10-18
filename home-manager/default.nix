{ lib, pkgs, specialArgs, ... }: ({
  imports = [
    ./dev.nix
    ./git.nix
    ./tmux.nix
    ./vim.nix
  ];

  config = {
    # Pass stateVersion from NixOS config
    home.stateVersion = specialArgs.nixosConfig.system.stateVersion;

    home.packages = with pkgs; [
      dua
      fd
      jq
      lsof
      nixfmt
      ripgrep
      tree
      unzip
      zip
    ];

    home.keyboard = {
      layout = "us";
      variant = "alt-intl-unicode";
    };

    programs = {
      bat.enable = true;
      bash = {
        enable = true;
        historyControl = ["erasedups" "ignoredups" "ignorespace"];
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      fish.enable = true;
      fzf = {
        enable = true;
        fileWidgetCommand = "fd --type f";
        fileWidgetOptions = ["--preview 'bat {}'"];
        changeDirWidgetCommand = "fd --type d";
        changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
      };
      htop = {
        enable = true;
        settings = {
          left_meters = [ "LeftCPUs2" "Memory" "Swap" ];
          right_meters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
        };
      };
      starship = {
        enable = true;
        settings.time = {
          disabled = false;
          format = "[$time]($style) ";
        };
      };
    };
  };
})
