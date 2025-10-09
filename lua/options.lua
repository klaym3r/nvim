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
opt.clipboard:append("unnamedplus")

-- Files
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.fileformat = "unix"
opt.encoding = "utf-8"

-- Indentation
opt.smartindent = true
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2

-- Splits
opt.splitbelow = true
opt.splitright = true
