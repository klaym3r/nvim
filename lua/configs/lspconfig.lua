-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "clangd", "omnisharp", "pyright" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.ts_ls.setup {
  on_attach = function (client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
  end,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  cmd = { "typescript-language-server", "--stdio" },
}

lspconfig.omnisharp.setup {
  cmd = { "/usr/bin/omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}


-- lspconfig.pyright.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--
--   settings = {
--     python = {
--       analysis = {
--         typeCheckingMode = "off",
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = true,
--       }
--     }
--   }
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
