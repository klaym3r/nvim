-- load nvchad defaults (оставляем, как у вас было)
require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

-- удобная таблица серверов, которые хотим включить
local servers = {
  "html",
  "cssls",
  "clangd",
  "omnisharp",
  "pyright",
  "kotlin_language_server",
}

-- Общая функция для безопасного расширения/регистрации конфига
local function extend_config(name, opts)
  -- vim.lsp.config(name, opts) — зарегистрирует/расширит конфиг для name
  -- Если opts == nil, это просто оставит дефолт.
  if opts == nil then
    opts = {}
  end
  -- merge лишь базовые поля (on_attach/on_init/capabilities) когда переданы
  opts.on_attach = opts.on_attach or nvlsp.on_attach
  opts.on_init = opts.on_init or nvlsp.on_init
  opts.capabilities = opts.capabilities or nvlsp.capabilities

  vim.lsp.config(name, opts)
end

-- Примеры: регистрируем простые расширения для списка серверов
for _, name in ipairs(servers) do
  extend_config(name, {}) -- доп. параметры можно добавить при необходимости
end

-- TypeScript: явная конфигурация (используем имя 'tsserver' и меняем cmd/filetypes)
extend_config("tsserver", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "typescript.tsx" },
  -- вызываем nvchad on_attach и одновременно отключаем форматирование у tsserver
  on_attach = function(client, bufnr)
    -- если вы используете отдельный форматтер (null-ls, eslint), отключаем форматирование у tsserver:
    client.server_capabilities.documentFormattingProvider = false
    if nvlsp.on_attach then
      nvlsp.on_attach(client, bufnr)
    end
  end,
  capabilities = nvlsp.capabilities,

  root_markers = { {'tsconfig.json', 'package.json'}, '.git' },
})

-- Omnisharp: путь можно указать полный или просто 'omnisharp' если в PATH
-- extend_config("omnisharp", {
--   cmd = { "dotnet", "/home/klaymer/.local/share/omnisharp/OmniSharp.exe", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
-- })

-- Kotlin: добавляем настройки компилятора/форматирования (root_dir обычно уже определён в lsp/ конфигах)
extend_config("kotlin_language_server", {
  -- cmd можно опустить если бинар в PATH; укажите полный путь при необходимости
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  settings = {
    kotlin = {
      compiler = { jvm = { target = "17" } },
      formatting = { enabled = false },
    },
  },
})

extend_config("pyright", {
  settings = {
    python = {
      exclude = {
        "**/__pycache__",
        "**/.git",
        "**/env",
        "**/*.txt"
      },
      reportMissingImports = "warning",
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})

-- vim.lsp.enable(servers)

-- Включаем (auto-activate) нужные конфиги — vim.lsp.enable запускает автоприкрепление по filetypes/root
local to_enable = vim.tbl_extend("force", vim.deepcopy(servers), { "tsserver" })
-- Убираем дубли
local unique = {}
for _, v in ipairs(to_enable) do
  unique[v] = true
end

local enable_list = {}
for k, _ in pairs(unique) do
  table.insert(enable_list, k)
end

vim.lsp.enable(enable_list)

-- (опционально) уведомление о том, какие конфиги включены
-- vim.notify("Enabled LSP configs: " .. table.concat(enable_list, ", "), vim.log.levels.INFO)
