{ lib, inputs, config, pkgs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "omen_nixos"; # Define your hostname.
 
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "pt_PT.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_TIME = "pt_PT.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Remove default X11 packages.
  services.xserver.excludePackages = (with pkgs; [
    xterm
  ]);

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager= {
    gdm.enable = true;
    autoLogin = {
      enable = true;
      user = "celso";
    };
  };
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-music
    totem
    tali
    iagno
    hitori
    atomix
  ]);


  services = {
    syncthing = {
      enable = true;
      user = "celso";
      dataDir = "/home/celso/Documents";
      configDir = "/home/celso/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "Home NAS" = { id = "3UD3GXY-XB7N3NV-XXM7V33-5JUGYLZ-H4BN6PR-O2I5GK7-QUF4B5B-V3JIKQI"; };
        "Huawei Mate20 Pro" = { id = "H7AYPUW-7YB33DN-Z43OD42-ZECGIJH-ZOM4XDZ-YK6EGFD-C34YADK-2GHUSQY"; };
        "Huawei MediaPad" = { id = "CDFFGTI-W4WD677-VYBAWX2-7TJ7RZ3-BP7EOBG-AYDMYN4-QXNL4OT-XW6HLAU"; };
        "ISCTE" = { id = "TXYPW2C-ENARVSY-4HZEEZK-GSUQ6UM-Q6IKA6N-YHIRBBR-QLOTZ5K-F7HKGA2"; };
      };
      folders = {
        "books" = {
          id = "75nkg-4joak";
          path = "/home/celso/Documents/books";
          devices = [ "Home NAS" ];
        };
        "keepassxc" = {
          path = "/home/celso/Documents/keepass";
          devices = [ "Home NAS" "Huawei Mate20 Pro" "Huawei MediaPad" "ISCTE" ];
        };
        "obsidian" = {
          path = "/home/celso/Documents/obsidian";
          devices = [ "Home NAS" "Huawei Mate20 Pro" "Huawei MediaPad" "ISCTE" ];
        };
      };
    };

    tailscale = {
      enable = true;
    };
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };


  programs = {
    dconf.enable = true;

    firefox = {
      enable = true;
      languagePacks = [ "pt-PT" "en-US" ];
    };

    zsh.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "pt";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.celso = {
      description = "Celso Miranda";
      useDefaultShell = true;
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNEjRa9V1RmX55DQp/kfUd4mG5W9FTLfZR/40uDUYxm omen-laptop" ];
      passwordFile = "/persist/passwords/celso";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.syncthing-icon
    

    keepassxc
    
    vim
    wget
    git
    
    maple-mono-NF
  ];

  environment.shells = with pkgs; [ zsh ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    allowSFTP = false; # Don't set this if you need sftp
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  # configure impermanence
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

