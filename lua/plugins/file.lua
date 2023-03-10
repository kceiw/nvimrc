return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    opts = {},
    init = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "preservim/tagbar",
  },
  {
    "editorconfig/editorconfig-vim"
  }
}
