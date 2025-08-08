return {
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        term_colors = true,
        auto_integrations = true,
      })
    end,
  },
  {
    "morhetz/gruvbox"
  },
  {
    "NLKNguyen/papercolor-theme",
  },
  {
    "Shatur/neovim-ayu"
  },
  {
    "nordtheme/vim",
  },
  {
    "jnurmine/Zenburn"
  }
}
