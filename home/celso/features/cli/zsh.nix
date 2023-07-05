{
  zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    initExtra = ''
          path+=('/home/celso/.config/emacs/bin')
          path+=('/home/celso/.local/bin')
          export PATH
          '';
  };
}
