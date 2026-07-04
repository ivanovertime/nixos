{ pkgs, ... }:

let
  telaIcons = pkgs.tela-circle-icon-theme.override { colorVariants = [ "green" ]; };
  iconPath = name: "${telaIcons}/share/icons/Tela-circle-green-dark/scalable/apps/${name}.svg";
in
{
  # Add COSMIC icon aliases in the active Tela theme to avoid duplicate launchers.
  xdg.dataFile = {
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicFiles.svg".source = iconPath "file-manager";
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicTerm.svg".source = iconPath "terminal";
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicSettings.svg".source = iconPath "preferences-system";
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicEdit.svg".source = iconPath "text-editor";
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicPlayer.svg".source = iconPath "totem";
    "icons/Tela-circle-green-dark/scalable/apps/com.system76.CosmicReader.svg".source = iconPath "accessories-document-viewer";
    "icons/Tela-circle-green-dark/scalable/apps/org.gnome.Loupe.svg".source = iconPath "accessories-image-viewer";
  };
}
