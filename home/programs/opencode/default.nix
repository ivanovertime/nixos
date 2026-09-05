{ pkgs, pkgs-unstable, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      lsp = true;
      small_model = "opencode/mimo-v2.5-free";
      compaction = {
        auto = true;
        prune = true;
      };
      plugin = [
        "@sveltejs/opencode"
        "@tarquinen/opencode-dcp@3.1.15"
      ];
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        mcp-nixos = {
          type = "local";
          command = [ "mcp-nixos" ];
        };
      };
      permission = {
        bash = {
          "sudo *" = "deny";
          "rm *" = "ask";
          "git push*" = "ask";
          "git reset --hard*" = "ask";
        };
      };
    };

    skills = {
      lazy-senior-dev = ./skills/lazy-senior-dev;
      laravel = ./skills/laravel;
      nuxt = ./skills/nuxt;
      sveltekit = ./skills/sveltekit;
      vue = ./skills/vue;
      postgres = ./skills/postgres;
      frontend-design = ./skills/frontend-design;
    };
  };

  home.packages = [ pkgs.mcp-nixos ];

  xdg.configFile."opencode/AGENTS.md".text = ''
    This system is managed by Nix (NixOS + home-manager).
    Never hand-edit files under ~/.config that are symlinked into /nix/store
    (home-manager owns them). Instead, edit the Nix sources in ~/Source/nixos
    and rebuild with `sudo nixos-rebuild switch --flake .#spica`.
    If a config file is not nix-managed (plain file in ~/.config), it is free
    to edit directly.
  '';

  xdg.configFile."opencode/dcp.jsonc".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/dcp.schema.json",
      "enabled": true
    }
  '';

  programs.opencode.agents.quick = ''
    ---
    description: Cheap free model for simple chores - explain code, small edits, quick questions
    mode: primary
    model: opencode/nemotron-3.5-lightning-free
    ---
    You are a fast, efficient coding assistant. Keep responses short and to the point.
    For simple tasks, do exactly what is asked without extra exploration.
    If a task turns out to be complex or multi-file, say so and suggest switching back to the main agent.
  '';

  programs.opencode.commands.explain = ''
    ---
    description: Explain a file or concept using a free model
    model: opencode/nemotron-3.5-lightning-free
    ---
    Explain $ARGUMENTS clearly and concisely. Focus on what it does, how it works,
    and anything non-obvious. Use short code references instead of long quotes.
  '';

  programs.opencode.commands.commit = ''
    ---
    description: Generate a commit message from staged changes
    model: opencode/nemotron-3.5-lightning-free
    ---
    Run `git diff --cached` to see staged changes, then write a concise commit message.
    Match the repo's existing commit style (check `git log --oneline -10`).
    Reply with only the commit message, no explanations.
  '';
}
