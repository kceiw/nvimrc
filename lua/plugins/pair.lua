return {
  {
    "windwp/nvim-autopairs",
    config = true,
  },
  {
    "andymass/vim-matchup",
    config = function()
      require("nvim-treesitter.configs").setup({
        matchup = {
          enable = true,              -- mandatory, false will disable the whole extension
          disable = { },  -- optional, list of language that will be disabled
          -- [options]
        },
      })
    end,
  }
}
