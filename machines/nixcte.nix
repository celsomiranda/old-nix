{ config, lib, pkgs, ... }: {
  celso.machine = {
    role = "desktop";
    user = {
      name = "celso";
      config = {
        isNormalUser = true;
        initialHashedPassword = "$5$Xhv/BxP2DpVhzYfo$kjRvRbxvFouI3YqrUI7munFkBNSlEnBxbjxvIZCpWU6";
        extraGroups = [ "wheel" "video" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZ86tI/bIEGjV6J4mE2jJTnCdw0pdV+25BpsFDv9Wz9 celso@omen"
        ];
      };
      profile = {
        imports = [
          ../home-manager
        ];

        celso.irc.enable = true;

        programs = {
          ssh = {
            enable = true;
            includes = [
              config.age.secrets.ssh.path
            ];
          };

        };
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" "ssd" "space_cache=v2" ];
    };

  boot.initrd.luks.devices."nixrootencrypted".device = "/dev/disk/by-label/nix_encrypted";

  fileSystems."/persist" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" "ssd" "space_cache=v2" ];
      neededForBoot = true;
    };

  fileSystems."/etc/nixos" =
    {
      device = "/persist/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/log" =
    {
      device = "/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
      neededForBoot = true;
    };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;


  networking = {
    bridges.br0.interfaces = [ "eno1" ];
    interfaces = br0.useDHCP = true;
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.checkReversePath = "loose";
    firewall.allowedUDPPorts = [
      config.services.tailscale.port
    ];
  };

  age.secrets.ssh = {
    file = ./../secrets/ssh.age;
    owner = config.celso.machine.user.name;
  };

  # Persistence
  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos" # Config Files
      "/srv" # Service Data
      "/var/lib" # System Services Data
      "/var/log" # Logs
    ];
  };



  environment.systemPackages = with pkgs; [

  ];

  services.tailscale.enable = true;
}
