vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w" -- сохранить файл
      vim.cmd "split | terminal dotnet run" -- открыть терминал внизу и запустить
    end, { buffer = true, desc = "Run C# code" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w"
      vim.cmd "split | terminal . env/bin/activate.fish; python %"
    end, { buffer = true, desc = "Run Python code" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w"
      vim.cmd "!make -f Makefile" -- сборка
      vim.cmd "split | terminal ./a.out" -- запуск
    end, { buffer = true, desc = "Build & Run C++" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript" },
  callback = function()
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w"
      vim.cmd "split | terminal node %"
    end, { buffer = true, desc = "Run JS file with Node.js" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript" },
  callback = function()
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w"
      vim.cmd "split | terminal tsx %"
    end, { buffer = true, desc = "Run TS file" })
  end,
})
