{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    initExtra = ''
          path+=('/home/cjcma/.config/emacs/bin')
          path+=('/home/cjcma/.local/bin')
          export PATH
          '';
  };
}
