local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    json = { "prettier" }
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    black = {
      command = "black",
      args = { "--quiet", "-" },
      stdin = true,
    },
  },
}

return options
