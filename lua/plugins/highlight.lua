return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "bicep",
        "c",
        "comment",
        "cpp",
        "css",
        "c_sharp",
        "dockerfile",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "help",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "sql",
        "vim",
        "yaml"
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
        -- treesitter is slow in large file, so disable it.
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/972aa544efb56e2f2f53c5f3c2537e43467dd5cb/README.md?plain=1#L132-L139
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
        end,
      },
      indent = {
        enable = true
      },
      incremental_selection = {
        enable = true
      },
      autotag = {
        enable = true
      },
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    "HiPhish/nvim-ts-rainbow2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        rainbow = {
          enable = true,
          -- list of languages you want to disable the plugin for
          disable = { },
          -- Which query to use for finding delimiters
          query = 'rainbow-parens',
          -- Highlight the entire buffer all at once
          strategy = require 'ts-rainbow.strategy.global',
        }
      })
    end,
  }
}
