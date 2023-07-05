{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.omen-en00015p

    ./hardware-configuration.nix

    ../common/global
    ../common/users/celso

    ../common/optional/gnome.nix
    ../common/optional/wireless.nix
    ../common/optional/pipewire.nix
  ];

  networking = {
    hostName = "omenix";
    useDHCP = true;
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

  system.stateVersion = "23.05";
}
