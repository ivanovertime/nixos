{ pkgs, ... }:

let
  herdrCompletions = pkgs.runCommand "herdr-bash-completions" { } ''
    ${pkgs.herdr}/bin/herdr completion bash > $out
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # also for herdr's non-login panes
    initExtra = ''
      export EDITOR="hx"
      export VISUAL="hx"
      source ${herdrCompletions}

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

      # Gated rebuild: check the flake first, then activate. /etc/nixos symlinks
      # to ~/Source/nixos, so the bare switch command works from any cwd
      # (--flake .#spica only resolves inside the repo).
      nix() {
        if [ "$1" = "upgrade" ]; then
          shift
          command nix flake check /home/ivan/Source/nixos && sudo nixos-rebuild switch "$@"
        else
          command nix "$@"
        fi
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
