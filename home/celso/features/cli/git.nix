{
  programs.git = {
    enable = true;
    userName = "Celso Miranda";
    userEmail = "769237+celsomiranda@users.noreply.github.com";
    aliases = {
      ci = "commit";
      co = "checkout";
      s = "status";
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
    ignores = [ ".direnv" "result" ];
  };
}
