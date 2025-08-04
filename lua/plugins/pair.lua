return {
  {
    "windwp/nvim-autopairs",
    config = true,
  },
  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_treesitter_stopline = 500
      -- To enable the delete surrounding (ds%) and change surrounding (cs%) maps
      vim.g.matchup_surround_enabled = 1
      -- To enable the experimental transmute module: In insert mode, after changing text inside a word,
      -- matching words will be changed in parallel
      vim.g.matchup_transmute_enabled = 1
      -- To disable matching withing strings and comments but recognize symbols within comments
      -- Value 2 to indicate not to recognize anything in comment.
      vim.g.matchup_delim_noskips = 1
    end,
    config = true,
  }
}
