local enabled_languages = {
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
  "query",
  "sql",
  "typescript",
  "vim",
  "vimdoc",
  "yaml"
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    ft = enabled_languages,
    branch = "main",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      ensure_installed = enabled_languages,
      ft = enabled_languages,
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
    ft = enabled_languages,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
      require('rainbow-delimiters.setup').setup({
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
          vim = 'rainbow-delimiters.strategy.local',
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      })
    end,
  }
}
