{ pkgs-unstable, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs-unstable.opencode;

    settings = {
      lsp = true;
      mcp = {
        daisyui-gitmcp = {
          type = "remote";
          enabled = true;
          url = "https://gitmcp.io/saadeghi/daisyui";
        };
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
    };
  };
}
