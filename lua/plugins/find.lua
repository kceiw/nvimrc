return {
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },

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
}
