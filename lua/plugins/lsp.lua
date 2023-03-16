local opts = {
  noremap=true,
  silent=true
}

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = {
    noremap=true,
    silent=true,
    buffer=bufnr
  }

  vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>law", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>lrw", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>lw", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, bufopts)
end

local languages = {
  "lua_ls",
  "omnisharp",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "jsonls",
  "powershell_es",
  "prosemd_lsp",
  "pyright",
  "yamlls"
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local locallsp = require("lspconfig")

      for i = 1, #languages do
        locallsp[languages[i]].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- overwrite the settings for particular languages.

      locallsp["lua_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          lua_ls = {
            diagnostics = {
              globals = {"vim"},
            },
          },
        },
      })

      locallsp["omnisharp"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "OmniSharp" },
        settings = {
          omnisharp = {
            cmd = { "OmniSharp" },
            enable_editorconfig_support = true,
            enable_ms_build_load_projects_on_demand = true,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
          }
        }
      })

    end
  },
  {
    "williamboman/mason.nvim",
    opts = { }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = languages,
    }
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local util = require("formatter.util")
      require("formatter").setup({
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          c = {
            require("formatter.filetypes.c").clangformat,
          },
          cpp = {
            require("formatter.filetypes.cpp").clangformat,
          },
          cs = {
            require("formatter.filetypes.cs").dotnetformat,
          },
          json = {
            require("formatter.filetypes.json").fixjson,
          },
          -- Formatter configurations for filetype "lua" go here
          -- and will be executed in order
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
              -- Supports conditional formatting
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end

              -- Full specification of configurations is down below and in Vim help
              -- files
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end
          },
          markdown = {
            require("formatter.filetypes.markdown").prettier,
          },
          python = {
            require("formatter.filetypes.python").black,
          },
          yaml = {
            require("formatter.filetypes.yaml").pyaml,
          },

          -- Use the special "*" filetype for defining formatter configurations on
          -- any filetype
          ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace
          }
        }
      })
    end,
    init = function()
      local keymap_opts = {
        noremap = true,
        silent = true,
      },
      vim.keymap.set("n", "<leader>f", ":Format<CR>", keymap_opts)
      vim.keymap.set("n", "<leader>F", ":FormatWrite<CR>", keymap_opts)
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        json = { "jsonlint" },
        markdown = { "markdownlint" },
        python = { "pycodestyle" },
        yaml = { "yamllint" },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
  }
}
