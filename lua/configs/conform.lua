local options = {
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },

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
    prettier = {
      prepend_args = { "--single-quote", "--tab-width", "2", "--no-use-tabs" },
    },
  },
}

return options
