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
      "antosha417/nvim-lsp-file-operations",
      "Hoffs/omnisharp-extended-lsp.nvim",
    },
    keys = {
      { "<space>e", "<cmd>lua vim.diagnostic.open_float()<cr>", mode = "n", noremap = true, silent = true },
      { "[d", "<cmd>lua diagnostic.goto_prev()<cr>", mode = "n", noremap = true, silent = true },
      { "]d", "<cmd>lua diagnostic.goto_next()<cr>", mode = "n", noremap = true, silent = true },
      { "<space>q", "<cmd>lua diagnostic.setloclist()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>law", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lrw", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lw", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, mode = "n", noremap = true, silent = true },
      { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", mode = "n", noremap = true, silent = true },
      { "<leader>lf", function() vim.lsp.buf.format { async = true } end, mode = "n", noremap = true, silent = true },
    },
    init = function()
      -- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
      -- cmp_nvim_lsp is a dependency of cmp-nvim. So lsp has a dependency on cmp-nvim. That'll bring in cmp_nvim_lsp
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        require("lsp-file-operations").default_capabilities()
      )

      vim.lsp.config("*", {
        capabilities = capabilities
      })

      local nvim_data_path = vim.api.nvim_eval("stdpath('data')")
      local mason_packages_path = nvim_data_path .. "/mason/packages/"

      for key, value in pairs(languages) do
        local language_path = mason_packages_path .. value
        if vim.fn.isdirectory(language_path) ~= 0 then
          vim.lsp.enable(key)

          if key == "powershell_es" then
            vim.lsp.config("powershell_es", {
              bundle_path = language_path .. "/PowerShellEditorServices",
            })

          elseif key == "omnisharp" then
            local omnisharp_extended = require("omnisharp_extended")
            vim.lsp.config("omnisharp", {
              cmd = {
                "omnisharp",
                "-z", -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
                "--hostPID",
                tostring(vim.fn.getpid()),
                "DotNet:enablePackageRestore=false",
                "--encoding",
                "utf-8",
                "--languageserver",
              },
              settings = {
                FormattingOptions = {
                  -- Enables support for reading code style, naming convention and analyzer
                  -- settings from .editorconfig.
                  EnableEditorConfigSupport = true,
                  -- Specifies whether 'using' directives should be grouped and sorted during
                  -- document formatting.
                  OrganizeImports = true,
                },
                MsBuild = {
                  -- If true, MSBuild project system will only load projects for files that
                  -- were opened in the editor. This setting is useful for big C# codebases
                  -- and allows for faster initialization of code navigation features only
                  -- for projects that are relevant to code that is being edited. With this
                  -- setting enabled OmniSharp may load fewer projects and may thus display
                  -- incomplete reference lists for symbols.
                  LoadProjectsOnDemand = true,
                },
                RoslynExtensionsOptions = {
                  -- Enables support for roslyn analyzers, code fixes and rulesets.
                  EnableAnalyzersSupport = true,
                  -- Enables support for showing unimported types and unimported extension
                  -- methods in completion lists. When committed, the appropriate using
                  -- directive will be added at the top of the current file. This option can
                  -- have a negative impact on initial completion responsiveness,
                  -- particularly for the first few completion sessions after opening a
                  -- solution.
                  EnableImportCompletion = nil,
                  -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                  -- true
                  AnalyzeOpenDocumentsOnly = nil,
                  -- Enables the possibility to see the code in external nuget dependencies
                  EnableDecompilationSupport = nil,
                },
                RenameOptions = {
                  RenameInComments = true,
                  RenameOverloads = true,
                  RenameInStrings = true,
                },
                Sdk = {
                  -- Specifies whether to include preview versions of the .NET SDK when
                  -- determining which version to use for project loading.
                  IncludePrereleases = true,
                },
              },
              handlers = {
                ["textDocument/definition"] = omnisharp_extended.definition_handler,
                ["textDocument/typeDefinition"] = omnisharp_extended.type_definition_handler,
                ["textDocument/references"] = omnisharp_extended.references_handler,
                ["textDocument/implementation"] = omnisharp_extended.implementation_handler,
              },
            })
          end
        end
      end
    end,
  },
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = { }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = lsp_languages,
    }
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Ensure the linter tools are installed
        "flake8",
        "jsonlint",
        "markdownlint",
        "pylint",
        "yamllint",

        -- Ensure the formatter tools are installed
        "clang-format",
        "fixjson",
        "stylua",
        "prettier",
        "prettierd",
        "black",
        "yamlfmt",
      },
      auto_update = true,
    }
  },
  {
    "mhartington/formatter.nvim",
    keys = {
      { "<leader>f", "<cmd>Format<cr>", noremap = true, silent = true },
      { "<leader>F", "<cmd>FormatWrite<cr>", noremap = true, silent = true },
    },
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
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        json = { "jsonlint" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        python = { "pylint", "flake8" },
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
