return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = function()
      return (vim.env.NVIM_USE_AI == "1")
    end,
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
        filetypes = {
          c = true,
          cpp = true,
          cs = true,
          css = true,
          html = true,
          java = true,
          javascript = true,
          python = true,
          typescript = true,
          ps1 = true,
          sh = function ()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              -- disable for .env files
              return false
            end
            return true
          end,
          ["*"] = false,  -- disable for all other filetypes and ignore default `filetypes`
        }
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    cond = function()
      return (vim.env.NVIM_USE_AI == "1")
    end,
    config = function ()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = function()
      return (vim.env.NVIM_USE_AI == "1")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
    },
  },
}
