{ pkgs-unstable, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      lsp = true;
      small_model = "opencode/deepseek-v4-flash-free";
      compaction = {
        auto = true;
        prune = true;
      };
      plugin = [
        "@sveltejs/opencode"
        "@tarquinen/opencode-dcp@3.1.15"
      ];
      mcp = {
        github = {
          type = "local";
          command = [
            "npx"
            "-y"
            "@modelcontextprotocol/server-github"
          ];
          enabled = true;
        };
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
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
    };
  };

  xdg.configFile."opencode/dcp.jsonc".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/Opencode-DCP/opencode-dynamic-context-pruning/master/dcp.schema.json",
      "enabled": true
    }
  '';
}
