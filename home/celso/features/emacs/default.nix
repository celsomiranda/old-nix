{ pkgs, ... }: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  services = {
    emacs = {
      enable = true;
      defaultEditor = true;
      socketActivation.enable = true;
      client = {
        enable = true;
      };
    };
  };
}
