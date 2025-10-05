-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"
local servers = { "html", "cssls", "clangd", "omnisharp", "pyright", "kotlin_language_server" }

-- lsps with default config
for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = args.match
    for name, config in pairs(vim.lsp.config) do
      local def = require("lspconfig.util").default_config
      local ft_list = def.filetypes or {}
      if vim.tbl_contains(ft_list, ft) then
        vim.lsp.start(config)
      end
    end
  end,
})

vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
}

vim.lsp.config.omnisharp = {
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
