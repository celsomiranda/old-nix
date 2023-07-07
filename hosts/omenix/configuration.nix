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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

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

  networking = {
    hostName = "omen_nixos";
    extraHosts = ''
      10.84.0.10  svcads01.iscte-iul.pt
      10.84.0.11  svcaroot01.iscte-iul.pt
      10.84.0.12  svcasub01.iscte-iul.pt
    '';
  };


  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Lisbon";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.utf-8";
    supportedLocales = [ "pt_PT.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS =        "pt_PT.utf8";
      LC_IDENTIFICATION = "pt_PT.utf8";
      LC_MEASUREMENT =    "pt_PT.utf8";
      LC_MONETARY =       "pt_PT.utf8";
      LC_NAME =           "pt_PT.utf8";
      LC_NUMERIC =        "en_US.utf8";
      LC_PAPER =          "pt_PT.utf8";
      LC_TELEPHONE =      "pt_PT.utf8";
      LC_TIME =           "pt_PT.utf8";
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
      user = "cjcma";
    };
  };
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    epiphany
  ]) ++ (with pkgs.gnome; [
    geary
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
      user = "cjcma";
      dataDir = "/home/cjcma/Documents";
      configDir = "/home/cjcma/.config/syncthing";
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
          path = "/home/cjcma/Documents/books";
          devices = [ "Home NAS" ];
        };
        "keepassxc" = {
          path = "/home/cjcma/Documents/keepass";
          devices = [ "Home NAS" "Huawei Mate20 Pro" "Huawei MediaPad" "ISCTE" ];
        };
        "obsidian" = {
          path = "/home/cjcma/Documents/obsidian";
          devices = [ "Home NAS" "Huawei Mate20 Pro" "Huawei MediaPad" "ISCTE" ];
        };
      };
    };

    tailscale = {
      enable = true;
    };

    globalprotect = {
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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.cjcma = {
      description = "Celso Miranda";
      useDefaultShell = true;
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJNEjRa9V1RmX55DQp/kfUd4mG5W9FTLfZR/40uDUYxm omen-laptop" ];
      passwordFile = "/persist/passwords/cjcma";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection

    keepassxc
    brave
    libreoffice-fresh
    globalprotect-openconnect

    wget
    git
   
    nodejs_18

    maple-mono-NF
  ];

  environment.shells = with pkgs; [ zsh ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  services.languagetool = {
    enable = true;
  };

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

  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    flags = [ "--update-input" "nixpkgs" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

