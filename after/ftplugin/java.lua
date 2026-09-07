-- Глобально в options.lua стоит отступ в 2 пробела; в Java общепринятый — 4,
-- и jdtls форматирует именно так, иначе форматирование на сохранении
-- переставляло бы отступы после каждой правки.
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
