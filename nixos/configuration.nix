# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    # Impermanence
    inputs.impermanence.nixosModules.impermanence

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
      shell = pkgs.fish;
    };
  };


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

  environment.systemPackages = with pkgs; [
    jq
    wget
    htop
    pavucontrol
    pamixer
    playerctl
    # SWAY
    sway
    waybar
    swaylock
    swayidle
    wl-clipboard
    mako
    rofi
    wayland
    kitty
    firefox

  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };
  programs.waybar.enable = true;
  programs.fuse.userAllowOther = true;
  programs.zsh.enable = true;

  # AUDIO PIPEWIRE
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  time.timeZone = "Europe/Lisbon";
  console = {
    keyMap = "pt-latin9";
    font = "lat9w-16";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_PT.utf8";
      LC_IDENTIFICATION = "pt_PT.utf8";
      LC_MEASUREMENT = "pt_PT.utf8";
      LC_MONETARY = "pt_PT.utf8";
      LC_NAME = "pt_PT.utf8";
      LC_NUMERIC = "pt_PT.utf8";
      LC_PAPER = "pt_PT.utf8";
      LC_TELEPHONE = "pt_PT.utf8";
      LC_TIME = "pt_PT.utf8";
    };
  };

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  security = {
    # Only allow sudo execution by the Wheel Group
    sudo.execWheelOnly = true;
    # Allow swaylock to unlock de computer
    pam.services.swaylock = {
      text = "auth include login";
    };
  };

  # Tailscale is essential
  services.tailscale.enable = true;

  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0"];
      checkReversePath = "loose";
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    networkmanager.enable = true;
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up --accept-dns --accept-routes -authkey tskey-auth-kYhHRe5CNTRL-Nc5pMUxHJJSWz9z2yUEFNSmft9N1pyiK
    '';
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
