return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>ff", "<cmd>FzfLua files<cr>", "FZF files" },
      { "<Leader>fb", "<cmd>FzfLua buffers<cr>", "FZF buffers" },
      { "<Leader>fg", "<cmd>FzfLua live_grep<cr>", "FZF live grep" },
      { "<Leader>fm", "<cmd>FzfLua git_commits<cr>", "FZF git commits" },
      { "<Leader>fh", "<cmd>FzfLua helptags<cr>", "FZF helptags" },
      { "<Leader>ft", "<cmd>FzfLua tags<cr>", "FZF tags" },
    },
    opts = {}
  },
  {
    "smoka7/hop.nvim",
    init = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection
      vim.keymap.set("", "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, {remap=true})
      vim.keymap.set("", "F", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, {remap=true})
      vim.keymap.set("", "t", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, {remap=true})
      vim.keymap.set("", "T", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, {remap=true})
    end,
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran",
        extensions = {
          "hop-zh-by-flypy"
        },
      })
    end
  }
}


