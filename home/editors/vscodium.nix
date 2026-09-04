{ pkgs, pkgs-unstable, ... }:

{
  programs.vscodium = {
    enable = true;
    package = pkgs-unstable.vscodium.fhs;

    # Keep mutable extension dir so unpackaged extensions can still be installed
    # from the UI under ~/.vscode-oss.
    mutableExtensionsDir = true;

    profiles.default = {
      # settings.json is left unmanaged (user-owned file); update checks are
      # disabled via that file (update.mode = "none", extensions.autoCheckUpdates = false).
      # Keep these two true so home-manager does not generate settings.json.

      extensions =
        let
          ext = pkgs.vscode-extensions;
          optionalExt =
            path: if pkgs.lib.hasAttrByPath path ext then [ (pkgs.lib.attrByPath path null ext) ] else [ ];
        in
        builtins.concatLists [
          (optionalExt [
            "bierner"
            "github-markdown-preview"
          ])
          (optionalExt [
            "bierner"
            "markdown-checkbox"
          ])
          (optionalExt [
            "bierner"
            "markdown-emoji"
          ])
          (optionalExt [
            "bierner"
            "markdown-footnotes"
          ])
          (optionalExt [
            "bierner"
            "markdown-mermaid"
          ])
          (optionalExt [
            "bierner"
            "markdown-preview-github-styles"
          ])
          (optionalExt [
            "dbaeumer"
            "vscode-eslint"
          ])
          (optionalExt [
            "elixir-lsp"
            "vscode-elixir-ls"
          ])
          (optionalExt [
            "file-icons"
            "file-icons"
          ])
          (optionalExt [
            "github"
            "vscode-github-actions"
          ])
          (optionalExt [
            "jnoortheen"
            "nix-ide"
          ])
          (optionalExt [
            "jock"
            "svg"
          ])
          (optionalExt [
            "maciejdems"
            "add-to-gitignore"
          ])
          (optionalExt [
            "mkhl"
            "direnv"
          ])
          (optionalExt [
            "piotrpalarz"
            "vscode-gitignore-generator"
          ])
          (optionalExt [
            "redhat"
            "vscode-yaml"
          ])
          (optionalExt [
            "tomoki1207"
            "pdf"
          ])
          (optionalExt [
            "vue"
            "volar"
          ])
          (optionalExt [
            "yinfei"
            "luahelper"
          ])
          (optionalExt [
            "yzhang"
            "markdown-all-in-one"
          ])
        ];
    };
  };
}
