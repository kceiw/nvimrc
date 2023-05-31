return {
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        term_colors = true,
        integration = {
          cmd = true,
          hop = true,
          illuminate = true,
          markdown = true,
          mason = true,
          nvimtree = true,
          notify = true,
          treesitter = true,
          treesitter_context = true,
          telescope = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "bold" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          }
        }
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
    "ayu-theme/ayu-vim"
  },
  {
    "nordtheme/vim",
  },
  {
    "jnurmine/Zenburn"
  }
}
