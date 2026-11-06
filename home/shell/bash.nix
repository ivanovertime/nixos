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

      # Wrapper: `nix update` bumps inputs, verifies, and auto-reverts the lock on
      # failure; `nix upgrade` checks the flake, then activates. /etc/nixos
      # symlinks to ~/Source/nixos, so the bare switch works from any cwd
      # (--flake .#spica only resolves inside the repo).
      nix() {
        case "$1" in
          upgrade)
            shift
            command nix flake check /home/ivan/Source/nixos && sudo nixos-rebuild switch "$@"
            ;;
          update)
            shift
            command nix flake update /home/ivan/Source/nixos "$@" || return 1
            if command nix flake check /home/ivan/Source/nixos; then
              echo "flake.lock updated and verified"
            else
              git -C /home/ivan/Source/nixos checkout -- flake.lock
              echo "check failed — flake.lock reverted" >&2
              return 1
            fi
            ;;
          *)
            command nix "$@"
            ;;
        esac
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
