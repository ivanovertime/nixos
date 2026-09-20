{ pkgs, ... }:

{
  home.packages = [
    # previewer deps
    pkgs.bat
    pkgs.chafa
  ];

  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      hidden = false;
      ignorecase = true;
      dirfirst = true;
      scrolloff = 4;
      drawbox = true;
      icons = true;
      ifs = "\\n";
      info = [
        "custom"
        "size"
      ];
    };

    previewer = {
      source = ./previewer.sh;
      keybinding = "i";
    };

    commands = {
      # trash via gio instead of permanent delete
      trash = "%set -f; gio trash -- $fx";

      # git branch in the prompt
      on-cd = ''
        &{{
            branch=$(git symbolic-ref --short HEAD 2>/dev/null) || branch='''
            if [ -n "$branch" ]; then
                fmt="\033[34;1m%d\033[0m \033[32;1m[$branch]\033[0m %f"
            else
                fmt="\033[34;1m%d\033[0m %f"
            fi
            lf -remote "send $id set promptfmt \"$fmt\""
        }}
      '';

      # git status per file in the info column
      on-load = ''
        &{{
            cd "$(dirname "$1")" || exit 1
            [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" = false ] || exit 0

            cmds=""

            for file in "$@"; do
                case "$file" in
                    */.git|*/.git/*) continue;;
                esac

                status=$(git status --porcelain --ignored -- "$file" | cut -c1-2 | head -n1)

                if [ -n "$status" ]; then
                    cmds="$cmds addcustominfo \"$file\" \"$status\";"
                else
                    cmds="$cmds addcustominfo \"$file\" ''';"
                fi
            done

            if [ -n "$cmds" ]; then
                lf -remote "send $id :$cmds"
            fi
        }}
      '';
    };

    keybindings = {
      "." = "set hidden!";
      "~" = "set hidden!";
      D = "trash";
      "<delete>" = "trash";
    };

    extraConfig = "on-cd";
  };
}
