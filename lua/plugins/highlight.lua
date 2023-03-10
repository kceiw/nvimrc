return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
        "python",
        "sql",
        "vim",
        "yaml"
      },
      highlight = {
        enable = true
      },
      indent = {
        enable = true
      },
      autotag = {
        enable = true
      },
    }
  }
}
