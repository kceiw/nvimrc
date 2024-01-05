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
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python"
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
    ft = {
      "python"
    },
    init = function()
      vim.api.nvim_create_autocmd({"VimEnter", "TabEnter", "TabNewEntered"}, {
        desc = "Auto select virtualenv Nvim or tab open",
        pattern = "*",
        callback = function()
          local venv = vim.fn.findfile("Pipfile", vim.fn.getcwd() .. ";")
          if venv ~= "" then
            require("venv-selector").retrieve_from_cache()
          end
        end,
      })
  end,
  config = function()
    require("venv-selector").setup({
      pipenv_path = vim.env.WORKON_HOME
    })
  end,
},
}
