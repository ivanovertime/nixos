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
          # OpenChamber (openchamber/openchamber) is not in nixpkgs.vscode-extensions
          # yet, so package the Open VSX release declaratively.
          [
            (pkgs.vscode-utils.buildVscodeExtension {
              pname = "openchamber";
              version = "1.18.1";
              vscodeExtPublisher = "FedaykinDev";
              vscodeExtName = "openchamber";
              vscodeExtUniqueId = "FedaykinDev.openchamber";
              src = pkgs.fetchurl {
                url = "https://open-vsx.org/api/FedaykinDev/openchamber/1.18.1/file/FedaykinDev.openchamber-1.18.1.vsix";
                sha256 = "sha256-RL9VNH22Fg7+9gomOu3lpJjyIxgkbUaBb92CT5EBl6M=";
              };
            })
          ]
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
