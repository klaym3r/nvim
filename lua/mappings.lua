require "nvchad.mappings"

local map = vim.keymap.set

-- Форматирование
map("n", "<C-f>", function()
  require("conform").format { async = true, lsp_fallback = true }
end, { desc = "Format file" })

-- основные бинды
map("n", "<Leader>w", "<cmd>w<cr>")
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>")

-- Выход
map("n", "<Leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })
map("n", "<Leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })

-- Сплиты
map("n", "ss", "<C-w>s", { desc = "Split horizontal" })
map("n", "sv", "<C-w>v", { desc = "Split vertical" })

-- Навигация по окнам
map("n", "sh", "<C-w>h")
map("n", "sl", "<C-w>l")
map("n", "sj", "<C-w>j")
map("n", "sk", "<C-w>k")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- Буферы
map("n", "<Leader>n", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Инкремент и декремент
map("n", "=", "<C-a>", { desc = "Increment" })
map("n", "-", "<C-x>", { desc = "Decrement" })

-- Выделить всё
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- NvimTree
map("n", "<Leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
map("n", "<Leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus NvimTree" })

-- Отключить поиск
map("n", ",<space>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Telescope
map("n", ",f", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", ",g", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", ",b", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", ",h", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
