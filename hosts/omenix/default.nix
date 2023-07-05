{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.omen-en00015p

    ../common/optional/systemd-boot.nix
    ./hardware-configuration.nix

    ../common/global
    ../common/users/celso

    ../common/optional/wireless.nix
    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
  ];

  networking = {
    hostName = "omenix";
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
  };

  # Lid settings
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  system.stateVersion = "23.05";
}
