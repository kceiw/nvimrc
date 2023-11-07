return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local nvim_data_path = vim.api.nvim_eval("stdpath('data')")
      local mason_packages_path = nvim_data_path .. "/mason/packages/"
      local opts = {
        noremap=true,
        silent=true
      }

      vim.keymap.set("n", "<F5>", "<cmd>lua require(\"dap\").continue()<CR>", opts)
      vim.keymap.set("n", "S+<F5>", "<cmd>lua require(\"dap\").terminate()<CR>", opts)
      vim.keymap.set("n", "<F9>", "<cmd>lua require(\"dap\").toggle_breakpoint()<CR>", opts)
      vim.keymap.set("n", "<F10>", "<cmd>lua require(\"dap\").step_over()<CR>", opts)
      vim.keymap.set("n", "<F11>", "<cmd>lua require(\"dap\").step_into()<CR>", opts)
      vim.keymap.set("n", "<F12>", "<cmd>lua require(\"dap\").step_out()<CR>", opts)
      vim.keymap.set("n", "S+<F9>", "<cmd>lua require(\"dap\").set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
      vim.keymap.set("n", "A+<F9>", "<cmd>lua require(\"dap\").set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
      vim.keymap.set("n", "<F7>", "<cmd>lua require(\"dap\").repl.open()<CR>", opts)
      vim.keymap.set("n", "<F6>", "<cmd>lua require(\"dap\").run_last()<CR>", opts)

    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      os = require("os")

      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "coreclr", "bash" },
        handlers = {
        },
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "ChristianChiarulli/neovim-codicons",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
