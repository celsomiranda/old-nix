{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./nix-index.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./zsh.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    diffsitter # Better diff
    tldr

    nil # Nix LSP
    nixfmt # Nix formatter

    shellcheck

    terraform
    terraform-ls

    ansible
    ansible-lint

    ltex-ls # Spell checking LSP
  ];
}
