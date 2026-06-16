{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    vimAlias = true;
    viAlias = true;
    extraConfig = ''
      " Minimal Neovim defaults using terminal-native colors.
      set number
      set relativenumber
      set mouse=a
      set clipboard=unnamedplus

      set tabstop=2
      set shiftwidth=2
      set expandtab
      set smartindent

      set ignorecase
      set smartcase
      set incsearch
      set hlsearch

      set notermguicolors
      set background=dark
      colorscheme default
      set signcolumn=yes
      set updatetime=300
    '';
  };
}
