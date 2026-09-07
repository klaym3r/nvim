local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- ЗАПУСК КОДА (<leader>z)
-- %s подставляется через shellescape, поэтому пути с пробелами не ломаются.
local runners = {
  cs = "dotnet run",
  python = "uv run %s",
  javascript = "node %s",
  typescript = "tsx %s",
}

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = vim.tbl_keys(runners),
  callback = function(ev)
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "write"
      local file = vim.fn.shellescape(vim.api.nvim_buf_get_name(ev.buf))
      vim.cmd("split | terminal " .. runners[ev.match]:format(file))
    end, { buffer = ev.buf, desc = "Run code" })
  end,
})

-- C++: сборка + запуск. Если make упал — терминал не открываем,
-- иначе запускался бы предыдущий (устаревший) бинарь.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "cpp",
  callback = function(ev)
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "write"
      local out = vim.fn.system { "make", "-f", "Makefile" }
      if vim.v.shell_error ~= 0 then
        vim.notify(out, vim.log.levels.ERROR, { title = "make failed" })
        return
      end
      vim.cmd "split | terminal ./a.out"
    end, { buffer = ev.buf, desc = "Build & Run C++" })
  end,
})

-- Java: компиляция + запуск. Как и в C++, при ошибке компиляции терминал не
-- открываем, чтобы не запустить прошлые .class.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "java",
  callback = function(ev)
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "write"

      local file = vim.api.nvim_buf_get_name(ev.buf)
      local root = vim.fn.fnamemodify(file, ":h")
      local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)

      -- Запускаем класс, в котором объявлен main, а не класс по имени файла:
      -- в Main.java класса Main может не быть вовсе (вся лаба лежит в DTclass),
      -- и java тогда подхватывала одноимённый .class от прошлой сборки.
      local class, seen
      for _, line in ipairs(lines) do
        seen = line:match "^%s*[%w%s]-class%s+([%w_]+)" or seen
        if seen and line:find "static" and line:find "void%s+main%s*%(" then
          class = seen
          break
        end
      end

      class = class or vim.fn.fnamemodify(file, ":t:r")

      -- java запускается по полному имени класса, а не по пути к файлу.
      -- Заодно из объявления пакета считаем корень исходников: пакет foo.bar
      -- лежит в <root>/foo/bar, так что поднимаемся на столько же уровней —
      -- без этого javac не найдёт соседние классы проекта.
      for _, line in ipairs(lines) do
        local pkg = line:match "^%s*package%s+([%w_.]+)%s*;"
        if pkg then
          class = pkg .. "." .. class
          for _ in pkg:gmatch "[^.]+" do
            root = vim.fn.fnamemodify(root, ":h")
          end
          break
        end
      end

      -- Куда складывать .class: по умолчанию корень исходников, то есть рядом
      -- с самим файлом (пакеты javac разложит по подкаталогам сам). Общий
      -- каталог на все проекты не годился — .class от прошлой лабы переживал
      -- сборку, и java запускала чужой класс.
      -- Переопределяется файлом .javac-out рядом с проектом или выше: одна
      -- строка с путём, относительный отсчитывается от каталога .javac-out.
      local out = root
      local cfg = vim.fs.find(".javac-out", { path = root, upward = true })[1]

      if cfg then
        local dir = vim.trim(vim.fn.readfile(cfg)[1] or "")
        if dir ~= "" then
          dir = vim.fn.expand(dir)
          out = vim.startswith(dir, "/") and dir or vim.fs.dirname(cfg) .. "/" .. dir
        end
      end

      local log = vim.fn.system { "javac", "-d", out, "-sourcepath", root, file }

      if vim.v.shell_error ~= 0 then
        vim.notify(log, vim.log.levels.ERROR, { title = "javac failed" })
        return
      end

      vim.cmd(("split | terminal java -cp %s %s"):format(vim.fn.shellescape(out), class))
    end, { buffer = ev.buf, desc = "Build & Run Java" })
  end,
})

-- NvimTree: сделать узел под курсором новым корнем
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "NvimTree",
  callback = function(ev)
    vim.keymap.set("n", "<C-CR>", function()
      require("nvim-tree.api").tree.change_root_to_node()
    end, { buffer = ev.buf, silent = true, desc = "Change root to node" })
  end,
})

-- Не продолжать комментарий на новой строке.
-- Именно opt_local: formatoptions — буферная опция, и ftplugin выставляет её
-- заново для каждого буфера, так что глобальный vim.opt тут ничего не решает.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

-- Подсветить скопированный кусок
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank { higroup = "Visual", timeout = 150 }
  end,
})

vim.filetype.add {
  pattern = {
    -- Если путь содержит /tasks/ или /roles/, либо файл называется playbook.yml
    [".*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*%.ya?ml"] = "yaml.ansible",
    [".*playbook%.ya?ml"] = "yaml.ansible",
  },
}
