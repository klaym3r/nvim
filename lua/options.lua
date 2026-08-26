require "nvchad.options"

local opt = vim.opt

-- UI
-- opt.mouse = "" -- отключаем мышь
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 7

-- Clipboard
-- Присваиваем, а не :append — иначе при повторном source в списке
-- появляется второй "unnamedplus".
opt.clipboard = "unnamedplus"

-- Files
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.fileformat = "unix"
-- opt.encoding в nvim всегда utf-8 и менять его нельзя — строка была no-op

-- Indentation
opt.smartindent = true
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Wrapping
opt.wrap = true
opt.linebreak = true -- перенос по границе слова, а не посреди него

opt.guicursor = "a:block-Cursor"
