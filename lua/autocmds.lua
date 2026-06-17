-- ЗАПУСК КОДА (<leader>z)
local runners = {
  cs = "dotnet run",
  python = "uv run %",
  javascript = "node %",
  typescript = "tsx %",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(runners),
  callback = function(ev)
    vim.keymap.set("n", "<leader>z", function()
      vim.cmd "w" -- сохранить файл
      vim.cmd("split | terminal " .. runners[ev.match]) -- терминал внизу + запуск
    end, { buffer = ev.buf, desc = "Run code" })
  end,
})

-- C++: сборка + запуск (отдельно — два шага)
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

-- NvimTree cd
local function change_root_to_node()
  require("nvim-tree.api").tree.change_root_to_node()
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.keymap.set(
      "n",
      "<C-CR>",
      change_root_to_node,
      { buffer = true, noremap = true, silent = true, desc = "Change root to node" }
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
})
