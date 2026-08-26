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
