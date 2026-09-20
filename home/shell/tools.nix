{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    icons = "always";
    colors = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    extraPackages = with pkgs; [
      chafa
    ];

    flavors = {
      "everforest-medium" = pkgs.fetchFromGitHub {
        owner = "Chromium-3-Oxide";
        repo = "everforest-medium.yazi";
        rev = "e1ead7b5a3bfc8eb572fd269a369775842752705";
        hash = "sha256-2Fx7+xnSsc+aVHBZUtLtVUDEzb1y8BcPBASciKk8x7o=";
      };
    };

    settings = {
      mgr = {
        ratio = [
          1
          4
          3
        ];
        sort_dir_first = true;
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        wrap = "yes";
        tab_size = 4;
        max_width = 8192;
        max_height = 8192;
        image_filter = "lanczos3";
        image_quality = 90;
      };
    };

    theme = {
      flavor = {
        dark = "everforest-medium";
      };
    };
  };
}
