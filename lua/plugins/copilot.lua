return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = false,
        },
        panel = {
          enabled = false,
          auto_refresh = false,
          layout = {
            position = "right",
          }
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    depedencies = { "zbirenbaum/copilot.lua" },
    config = true,
  }
}
