local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    json = { "prettier" }
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
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
