local options = {
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },

  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
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
    prettier = {
      prepend_args = { "--single-quote", "--tab-width", "2", "--no-use-tabs" },
    },
  },
}

return options
