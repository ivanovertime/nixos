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
      agent = {
        explore = {
          model = "opencode/mimo-v2.5-free";
        };
        plan = {
          color = "info";
        };
        build = {
          color = "warning";
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

  programs.opencode.agents.ask = ''
    ---
    description: Read-only Q&A agent - answers questions about the codebase without touching anything
    mode: primary
    model: opencode/mimo-v2.5-free
    color: success
    permission:
      edit: deny
      bash: deny
    ---
    You are a read-only assistant. Answer questions by reading and searching
    the codebase only. Never modify files or run state-changing commands.
    Keep answers concise and cite file:line references.
  '';

  programs.opencode.commands.explain = ''
    ---
    description: Explain a file or concept using a free model
    model: opencode/mimo-v2.5-free
    ---
    Explain $ARGUMENTS clearly and concisely. Focus on what it does, how it works,
    and anything non-obvious. Use short code references instead of long quotes.
  '';

  programs.opencode.commands.commit = ''
    ---
    description: Commit all working-tree changes, grouped as one or more conventional commits
    model: opencode/mimo-v2.5-free
    ---
    Commit the user's changes for them.

    Use the bash tool to run the commands yourself - do not just describe them.
    1. Inspect the repo state: `git status --short`, `git diff` (unstaged),
       and `git diff --cached` (already staged). Check the repo's commit style
       with `git log --oneline -10`.
    2. Group the changes into one or more logical commits by concern. Follow
       conventional commits: `type(scope): subject`. Derive the scope from the
       files' area (e.g. home/shell/* -> shell, home/programs/opencode/* ->
       opencode, flake.lock -> deps). Keep related changes together; split
       unrelated concerns into separate commits.
    3. For each group: stage its files with `git add`, then run `git commit -m
       "<full conventional commit message>"`.
    4. Never push. Never stage files unrelated to the commit you are about to make.

    Reply to the user in the language they are using (English or Spanish).
    Write commit messages in English to match the repo's history.
    Summarize what was committed (or what you skipped) in a few lines.
  '';
}
