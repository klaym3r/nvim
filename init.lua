vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)


-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  {
    "typicode/bg.nvim",
    lazy = false,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"
require "autocmds"
require "snippets"

vim.schedule(function()
  require "mappings"
end)

vim.env.JAVA_HOME = "/usr/lib/jvm/java-17-openjdk"
vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH

-- функция перезагрузки темы для NvChad
local function reload_theme()

  local file = io.open(os.getenv("HOME") .. "/.config/nvchad_theme_name", "r")
  if not file then return end

  local new_theme = file:read("*all"):gsub("%s+", "")
  file:close()

  local nvconfig = require("nvconfig")
  if nvconfig.base46.theme == new_theme then return end

  nvconfig.base46.theme = new_theme
  require("plenary.reload").reload_module("base46")

  local base46 = require("base46")
  base46.compile()
  base46.load_all_highlights()
end

vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    vim.schedule(reload_theme)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    reload_theme()
  end,
})
