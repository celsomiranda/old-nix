# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # inputs.nix-colors.homeManagerModule
    #inputs.impermanence.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "celso";
    homeDirectory = "/home/celso";
  };

  programs = {
    home-manager.enable = true;
    neovim.enable = true;

    git = {
      enable = true;
      userName = "Celso Miranda";
      userEmail = "769237+celsomiranda@users.noreply.github.com";
    };

    zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        dotDir = ".config/zsh";
    };
  };

  home.packages = with pkgs; [
    nixfmt
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
