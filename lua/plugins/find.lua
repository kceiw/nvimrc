return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },

    config = true,

    init = function()
      local builtin = require("telescope.builtin")
      local keymap_opts = {
        noremap = true
      }
      vim.keymap.set("n", "<Leader>ff", builtin.find_files, keymap_opts)
      vim.keymap.set("n", "<Leader>fb", builtin.buffers, keymap_opts)
      vim.keymap.set("n", "<Leader>fg", builtin.live_grep, keymap_opts)
      vim.keymap.set("n", "<Leader>fh", builtin.help_tags, keymap_opts)
    end
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
  },
}
