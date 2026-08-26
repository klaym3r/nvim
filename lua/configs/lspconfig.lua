require("nvchad.configs.lspconfig").defaults()

-- NvChad в defaults() уже делает:
--   vim.lsp.config("*", { capabilities = ..., on_init = ... })
--   автокоманду LspAttach, которая вешает on_attach на любой сервер
--   config + enable для lua_ls
-- Поэтому здесь нужны только собственные настройки серверов: прописывать
-- on_attach/on_init/capabilities руками не надо (раньше из-за этого on_attach
-- отрабатывал по два раза на каждый сервер).

-- Форматирование отдаём conform, у сервера его выключаем.
local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

-- Единственный источник правды: сервер -> его настройки ({} = дефолты NvChad).
local servers = {
  html = {},
  cssls = {},
  clangd = {},
  omnisharp = {},
  bashls = {},

  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { { "tsconfig.json", "package.json" }, ".git" },
    init_options = {
      preferences = {
        quotePreference = "single",
      },
    },
    on_attach = disable_formatting,
  },

  prismals = {
    cmd = { "prisma-language-server", "--stdio" },
    filetypes = { "prisma" },
  },

  pyright = {
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
  },

  ruff = {
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    -- ruff отдаёт позиции в utf-16; без этого он расходится с pyright
    capabilities = {
      general = { positionEncodings = { "utf-16" } },
    },
    on_attach = disable_formatting,
  },

  kotlin_language_server = {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" },
    settings = {
      kotlin = {
        compiler = { jvm = { target = "17" } },
        formatting = { enabled = false },
      },
    },
  },

  ansiblels = {
    filetypes = { "yaml.ansible" },
    settings = {
      ansible = {
        ansible = {
          path = "ansible",
        },
        validation = {
          enabled = true,
          lint = {
            enabled = true,
            path = "ansible-lint",
          },
        },
      },
    },
  },
}

-- Omnisharp: раскомментировать если нужен конкретный бинарь
-- servers.omnisharp = {
--   cmd = { "dotnet", vim.fn.expand "~/.local/share/omnisharp/OmniSharp.exe",
--     "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
-- }

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
end

vim.lsp.enable(vim.tbl_keys(servers))
