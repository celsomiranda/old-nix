{ inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./network.nix
    ./quietboot.nix
    ./auto-upgrade.nix
    ./ephemeral-btrfs.nix
    ./locale.nix
    ./nix.nix
    ./zsh.nix
    ./sops.nix
    ./optin-persistence.nix
    ./podman.nix
    ./pipewire.nix
    ./systemd-boot.nix
    ./tailscale.nix
    ./globalprotect.nix
  ];

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  environment.enableAllTerminfo = true;

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}
