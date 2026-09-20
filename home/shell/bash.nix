{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # herdr panes run non-login interactive shells, so this is set here
    # (rather than via login profile) so $EDITOR is hx inside herdr too.
    initExtra = ''
      export EDITOR="hx"
      export VISUAL="hx"
    '';
    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      ll = "eza --long --git --icons=always --group-directories-first --header";
      la = "eza --all --icons=always --group-directories-first";
      lla = "eza --long --all --git --icons=always --group-directories-first --header";
      lt = "eza --tree --icons=always";
      livetoken = "journalctl --user -u livebook --no-pager 2>/dev/null | grep -oP 'token=\\K[a-z0-9]+' | tail -1";
      hd = "herdr";
      crp = "pkill cosmic-panel";
    };
  };
}
