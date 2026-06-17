vim.o.tabstop = 2
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.wrap = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"

local map = vim.keymap.set

vim.g.mapleader = " "
map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map('n', ',<space>', '<cmd>nohlsearch<CR>')

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
vim.keymap.set('n', ',f', ":Pick files<CR>")
vim.keymap.set('n', ',h', ":Pick help<CR>")
vim.keymap.set('n', ',g', ":Pick grep_live<CR>")

require "oil".setup()
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

vim.lsp.enable({ "lua_ls", "tsserver", "pyright" })
map('n', '<leader>f', function()
	vim.lsp.buf.format { async = true }
end, {})
map('n', '<leader>rn', vim.lsp.buf.rename)
map('n', 'gd', vim.lsp.buf.definition)

-- colors
require "tokyonight".setup({ transparent = true })
vim.cmd [[colorscheme tokyonight-night]]
vim.cmd(":hi statusline guibg=NONE")
