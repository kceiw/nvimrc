local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  -- Default mappings. Feel free to modify or remove as you wish.
  api.config.mappings.default_on_attach(bufnr)

  -- Mappings removed via:
  --   remove_keymaps
  --   OR
  --   view.mappings.list..action = ""
  --
  -- The dummy set before del is done for safety, in case a default mapping does not exist.
  --
  -- You might tidy things by removing these along with their default mapping.

  vim.keymap.del("n", "<C-v>", { buffer = bufnr })

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set("n", "A", api.tree.expand_all, opts("Expand All"))
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "cd", api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
  vim.keymap.set("n", "ov", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "oh", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "U", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "P", function()
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
  end, opts("Print Node Path"))

  vim.keymap.set("n", "Z", api.node.run.system, opts("Run System"))
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    init = function()
      -- disable netrw at the very start of your init.lua (strongly advised)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require("nvim-tree").setup({
        on_attach = nvim_tree_on_attach
      })
    end,
  },
  {
    "coffebar/transfer.nvim",
    lazy = true,
    cmd = {
      "TransferInit",
      "DiffRemote",
      "TransferUpload",
      "TransferDownload",
      "TransferDirDiff",
      "TransferRepeat"
    },
    opts = {},
  },
}
