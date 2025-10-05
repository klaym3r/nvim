local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    json = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    kotlin = { "ktlint" },
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
