{ pkgs, ... }:

let
  # Generated once at build time rather than spawning herdr on every shell start.
  herdrCompletions = pkgs.runCommand "herdr-bash-completions" { } ''
    ${pkgs.herdr}/bin/herdr completion bash > $out
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # herdr panes run non-login interactive shells, so this is set here
    # (rather than via login profile) so $EDITOR is hx inside herdr too.
    initExtra = ''
      export EDITOR="hx"
      export VISUAL="hx"
      source ${herdrCompletions}

      # Leave the shell in the directory lf was last browsing.
      lf() {
        local tmp dir
        tmp="$(mktemp)"
        command lf -last-dir-path="$tmp" "$@"
        if [ -s "$tmp" ]; then
          dir="$(cat "$tmp")"
          [ -d "$dir" ] && cd "$dir"
        fi
        rm -f "$tmp"
      }
    '';
    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      ll = "eza --long --git --icons=always --group-directories-first --header";
      la = "eza --all --icons=always --group-directories-first";
      lla = "eza --long --all --git --icons=always --group-directories-first --header";
      lt = "eza --tree --icons=always";
      livetoken = "journalctl --user -u livebook --no-pager 2>/dev/null | grep -oP 'token=\\K[a-z0-9]+' | tail -1";
      hd = "herdr";
      cpr = "pkill cosmic-panel";
      oc = "opencode";
      cc = "claude";
    };
  };
}
