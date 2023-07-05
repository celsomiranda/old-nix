{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/celso

    ../common/optional/pipewire.nix
    ../common/optional/quietboot.nix
  ];

  networking = {
    hostName = "PC012367";
    useDHCP = true;
    # TODO ?
    interfaces.enp8s0 = {
      useDHCP = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  system.stateVersion = "23.05";
}
