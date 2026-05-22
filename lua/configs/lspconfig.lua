require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

local servers = {
  "html",
  "cssls",
  "clangd",
  "omnisharp",
  "bashls",
}

local function extend_config(name, opts)
  if opts == nil then
    opts = {}
  end
  opts.on_attach = opts.on_attach or nvlsp.on_attach
  opts.on_init = opts.on_init or nvlsp.on_init
  opts.capabilities = opts.capabilities or nvlsp.capabilities
  vim.lsp.config(name, opts)
end

for _, name in ipairs(servers) do
  extend_config(name, {})
end

extend_config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  init_options = {
    preferences = {
      quotePreference = "single",
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    if nvlsp.on_attach then
      nvlsp.on_attach(client, bufnr)
    end
  end,
  capabilities = nvlsp.capabilities,
  root_markers = { { "tsconfig.json", "package.json" }, ".git" },
})

extend_config("prismals", {
  cmd = { "prisma-language-server", "--stdio" },
  filetypes = { "prisma" },
})

extend_config("pyright", {
  settings = {
    python = {
      exclude = {
        "**/__pycache__",
        "**/.git",
        "**/env",
        "**/*.txt",
      },
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        diagnosticSeverityOverrides = {
          reportMissingImports = "warning",
        },
        ignore = { "*" },
        typeCheckingMode = "basic",
      },
    },
  },
})

extend_config("ruff", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    if nvlsp.on_attach then
      nvlsp.on_attach(client, bufnr)
    end
  end,
  capabilities = vim.tbl_deep_extend("force", nvlsp.capabilities, {
    general = { positionEncodings = { "utf-16" } },
  }),
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

extend_config("kotlin_language_server", {
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  settings = {
    kotlin = {
      compiler = { jvm = { target = "17" } },
      formatting = { enabled = false },
    },
  },
})

-- Omnisharp: раскомментировать если нужен конкретный бинарь
-- extend_config("omnisharp", {
--   cmd = { "dotnet", "/home/klaymer/.local/share/omnisharp/OmniSharp.exe", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
-- })

local to_enable = vim.deepcopy(servers)
table.insert(to_enable, "ts_ls")
table.insert(to_enable, "prismals")
table.insert(to_enable, "pyright")
table.insert(to_enable, "ruff")
table.insert(to_enable, "kotlin_language_server")

vim.lsp.enable(to_enable)
