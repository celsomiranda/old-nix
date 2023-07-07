{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.omen-en00015p

    ./hardware-configuration.nix

    ../common/global
    ../common/users/cjcma

    ../common/optional/power-management.nix
  ];

  networking = {
    hostName = "omenix";
    useDHCP = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  system.stateVersion = "23.05";
}
