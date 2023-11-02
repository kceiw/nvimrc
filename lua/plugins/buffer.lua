return {
  {
    "vim-scripts/scratch.vim",
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- Don't use lsp for detection method. It's not changed if a file in a different folder is opened.
        detection_methods = { "pattern" },
        patterns = { ".git" },
        exclude_dirs = { "node_modules", "pyenv", ".env" },

        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = false,

        -- What scope to change the directory, valid options are
        -- * global (default)
        -- * tab
        -- * win
        scope_chdir = "tab",

        -- Path where project.nvim will store the project history for use in
        -- telescope
        datapath = vim.fn.stdpath("data"),

      })
    end,
  }
}
