{ pkgs-unstable, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      lsp = true;
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
        postgres = {
          type = "local";
          command = [
            "docker"
            "run"
            "-i"
            "--rm"
            "--network"
            "host"
            "-e"
            "DATABASE_URI=postgresql://postgres:postgres@localhost:5432/postgres"
            "crystaldba/postgres-mcp"
            "--access-mode=unrestricted"
          ];
        };
        laravel = {
          type = "local";
          command = [
            "php"
            "artisan"
            "mcp:run"
          ];
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
}
