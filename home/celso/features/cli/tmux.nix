{ pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 1;
    mouse = true;
    keyMode = "vi";
    newSession = true;
    shortcut = "a";
    extraConfig = ''
          unbind %
          bind | split-window -h

          unbind '"'
          bind - split-window -v

          bind '-' split-window -v -c "#{pane_current_path}"
          bind | split-window -h -c "#{pane_current_path}"
        '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = dracula;
        extraConfig = ''
              set -g @dracula-show-battery false
              set -g @dracula-show-powerline true
              set -g @dracula-refresh-rate 10
            '';
      }
    ];
  };
}
