return {
  {
    "numToStr/Comment.nvim",
    opts = {
      padding = true,
      sticky = true,
      ignore = "^(%s*)$",
    }
  },
  {
    "moevis/base64.nvim",
    cmd = {
      "Base64Decode",
      "Base64Encode",
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    ft = {
      "python"
    },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      {
        -- Keymap to open VenvSelector to pick a venv.
        "<leader>vs", "<cmd>:VenvSelect<cr>"
      },
      {
        -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
        "<leader>vc", "<cmd>:VenvSelectCached<cr>"
      }
    },
    config = function()
      require("venv-selector").setup({
        pipenv_path = vim.env.WORKON_HOME,
        stay_on_this_version = true
      })
    end,
  },
}
