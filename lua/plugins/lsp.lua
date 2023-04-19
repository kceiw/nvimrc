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
  ["clangd"] = "clangd",
  ["lua_ls"] = "lua-language-server",
  ["omnisharp"] = "omnisharp" ,
  ["bashls"] = "bash-language-server",
  ["dockerls"] = "dockerfile-language-server",
  ["docker_compose_language_service"] = "docker-compose-language-service",
  ["powershell_es"] = "powershell-editor-services",
  ["pyright"] = "pyright",
}

local lsp_languages = {
  "clangd",
  "lua_ls",
  "omnisharp",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "powershell_es",
  "pyright",
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim",
      "ms-jpq/coq_nvim",
    },
    config = function()
      local capabilities = require("coq").lsp_ensure_capabilities().capabilities
      local locallsp = require("lspconfig")

      local nvim_data_path = vim.api.nvim_eval("stdpath('data')")
      local mason_packages_path = nvim_data_path .. "/mason/packages/"

      for key, value in pairs(languages) do
        local language_path = mason_packages_path .. value
        if vim.fn.isdirectory(language_path) ~= 0 then
          if key == "lua_ls" then
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
          elseif key == "omnisharp" then
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
                   handlers = {
                    ["textDocument/definition"] = require('omnisharp_extended').handler,
                   }
                }
              }
            })
          elseif key == "powershell_es" then
            locallsp[key].setup({
              on_attach = on_attach,
              capabilities = capabilities,
              cmd = {"pwsh", "-Command", language_path .. "/PowerShellEditorServices"},
              settings = {
                powershell_es = {
                  bundle_path = language_path .. "/PowerShellEditorServices",
                }
              }
            })
          else
            locallsp[key].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end
        end
      end


    end
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
  },
  {
    "williamboman/mason.nvim",
    opts = { }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = lsp_languages,
    }
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Ensure the linter tools are installed
        "jsonlint",
        "markdownlint",
        "yamllint",

        -- Ensure the formatter tools are installed
        "clang-format",
        "fixjson",
        "stylua",
        "prettier",
        "prettierd",
        "black",
        "yamlfmt",
      }
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
            require("formatter.filetypes.yaml").yamlfmt,
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
}
