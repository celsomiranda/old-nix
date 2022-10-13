# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  # Set your hostname
  networking.hostName = "iscte";

  # Systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.mutableUsers = false;

  users.users = {

    celso = {
      # Skip setting a root password by passing '--no-root-passwd' to nixos-install.
      initialHashedPassword = "$5$Xhv/BxP2DpVhzYfo$kjRvRbxvFouI3YqrUI7munFkBNSlEnBxbjxvIZCpWU6";
      isNormalUser = true;
      #openssh.authorizedKeys.keys = [];
      extraGroups = [ "wheel" "video" "camera" "audio" "networkmanager" ];
    };
  };

  # Tailscale is essential
  services.tailscale.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = true;
  };

  # Used by SystemD
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos" # Config Files
      "/srv" # Service Data
      "/var/lib" # System Services Data
      "/var/log" # Logs
    ];
  };

  security.sudo.execWheelOnly = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
