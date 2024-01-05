return {
  {
    "preservim/tagbar",
  },
  {
    "ldelossa/litee.nvim",
    config = function()
        require("litee.lib").setup()
    end,
  },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      { "ldelossa/litee.nvim", }
    },
    config = function()
        require("litee.gh").setup()
    end,
  },
}
