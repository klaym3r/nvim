vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- JAVA_HOME нужен kotlin_language_server. Ставим только если путь существует:
-- иначе в PATH на каждом старте уезжает несуществующий префикс.
for _, dir in ipairs { vim.env.JAVA_HOME, "/usr/lib/jvm/java-17-openjdk", "/usr/lib/jvm/default" } do
  if dir and vim.uv.fs_stat(dir) then
    vim.env.JAVA_HOME = dir
    vim.env.PATH = dir .. "/bin:" .. vim.env.PATH
    break
  end
end

require "options"
require "nvchad.autocmds"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Сниппеты тянут за собой luasnip, поэтому грузим их при первом входе в insert,
-- а не на старте — иначе ленивая загрузка luasnip теряет смысл.
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require "snippets"
  end,
})
