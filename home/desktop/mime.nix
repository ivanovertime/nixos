{ ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser
      "text/html" = [ "google-chrome.desktop" ];
      "application/xhtml+xml" = [ "google-chrome.desktop" ];
      "application/x-www-form-urlencoded" = [ "google-chrome.desktop" ];
      "x-scheme-handler/about" = [ "google-chrome.desktop" ];
      "x-scheme-handler/ftp" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];

      # Images
      "image/apng" = [ "com.system76.CosmicViewer.desktop" ];
      "image/avif" = [ "com.system76.CosmicViewer.desktop" ];
      "image/bmp" = [ "com.system76.CosmicViewer.desktop" ];
      "image/gif" = [ "com.system76.CosmicViewer.desktop" ];
      "image/heic" = [ "com.system76.CosmicViewer.desktop" ];
      "image/jpeg" = [ "com.system76.CosmicViewer.desktop" ];
      "image/jpg" = [ "com.system76.CosmicViewer.desktop" ];
      "image/jxl" = [ "com.system76.CosmicViewer.desktop" ];
      "image/png" = [ "com.system76.CosmicViewer.desktop" ];
      "image/svg+xml" = [ "com.system76.CosmicViewer.desktop" ];
      "image/tiff" = [ "com.system76.CosmicViewer.desktop" ];
      "image/webp" = [ "com.system76.CosmicViewer.desktop" ];
      "video/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "application/mp4" = [ "io.github.celluloid_player.Celluloid.desktop" ];
    };
  };
}
