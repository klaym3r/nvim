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

  -- Java. cmd не задаём: он приходит из nvim-lspconfig, который зовёт скрипт
  -- jdtls из PATH (~/.local/bin/jdtls) и на каждый проект заводит отдельный
  -- workspace в stdpath("cache")/jdtls. Форматирование оставляем серверу —
  -- для java в conform форматтера нет, и он честно падает в lsp_format.
  jdtls = {
    -- Без маркера проекта (pom.xml / build.gradle / .git) jdtls объявляет файл
    -- "non-project file" и репортит только синтаксис: ошибки типов молчат.
    -- Для папки с .java-файлами, какие обычно и раздают на курсе, маркера нет,
    -- поэтому корень доопределяем сами.
    root_dir = function(bufnr, on_dir)
      -- Порядок как в nvim-lspconfig: сначала маркеры многомодульных сборок,
      -- потом одномодульных.
      local root = vim.fs.root(bufnr, { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" })
        or vim.fs.root(bufnr, { "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" })

      if root then
        return on_dir(root)
      end

      local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
      local pkg

      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)) do
        pkg = line:match "^%s*package%s+([%w_.]+)%s*;"
        if pkg then
          break
        end
      end

      -- Пакет foo.bar лежит в <корень>/foo/bar: поднимаемся над каталогами
      -- пакета, иначе jdtls опять ругнётся на несовпадение имени пакета.
      if pkg then
        for _ in pkg:gmatch "[^.]+" do
          dir = vim.fs.dirname(dir)
        end

        if vim.fs.basename(dir) == "src" then
          dir = vim.fs.dirname(dir)
        end
      end

      -- Страховка: .java прямо в $HOME увёл бы корень в домашний каталог,
      -- и jdtls полез бы индексировать его целиком. Лучше остаться в
      -- single-file режиме, чем повесить редактор.
      if dir == vim.env.HOME then
        return on_dir(nil)
      end

      return on_dir(dir)
    end,

    settings = {
      java = {
        configuration = {
          -- Без явного списка рантаймов jdtls умеет собирать только под ту
          -- версию JDK, на которой запущен сам.
          runtimes = {
            {
              name = "JavaSE-21",
              path = vim.fn.expand "~/.local/share/jdk/temurin-21",
              default = true,
            },
          },
        },
        project = {
          -- Без build-файла jdtls считает корнем исходников сам каталог
          -- проекта и ругается на несовпадение пакета в src/foo/Bar.java.
          -- На Maven/Gradle-проекты настройка не влияет — там корни берутся
          -- из pom.xml / build.gradle.
          sourcePaths = { "src", "." },
        },
        -- Иначе goto-definition в стандартную библиотеку приводит в декомпиль
        -- без имён параметров вместо исходников.
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        signatureHelp = { enabled = true },
        implementationsCodeLens = { enabled = true },
        inlayHints = {
          parameterNames = { enabled = "literals" },
        },
        completion = {
          favoriteStaticMembers = {
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.junit.jupiter.api.Assertions.*",
          },
        },
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
