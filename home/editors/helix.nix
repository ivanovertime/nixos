{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "term16_dark";
      editor = {
        line-number = "relative";
        cursorline = true;
        true-color = true;
      };
    };

    languages = {
      language-server = {
        elixir-ls.command = "${pkgs.elixir-ls}/bin/elixir-ls";
        phpactor.command = "${pkgs.phpactor}/bin/phpactor";
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          auto-format = true;
        }
        {
          name = "elixir";
          language-servers = [ "elixir-ls" ];
          auto-format = true;
        }
        {
          name = "php";
          language-servers = [ "phpactor" ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" ];
          auto-format = true;
        }
      ];
    };
  };
}
