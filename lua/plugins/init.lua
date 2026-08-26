return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- catppuccin убран: тема идёт через base46 (chadrc theme = "kitty"),
  -- обычный colorscheme-плагин NvChad всё равно не использует.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Ветка main: setup() понимает только install_dir, а ensure_installed /
    -- auto_install / highlight / indent молча игнорируются. Подсветку включает
    -- сам NvChad (vim.treesitter.start в nvchad.autocmds), а парсеры ставим тут.
    config = function()
      local ts = require "nvim-treesitter"
      ts.setup {}

      -- Языки нужны не только для своих файлов, но и для ```блоков``` в markdown:
      -- инъекции подсвечиваются только при установленном парсере.
      local ensure_installed = {
        "vim", "vimdoc", "lua", "luadoc", "printf", "query",
        "html", "css", "javascript", "typescript", "tsx",
        "c", "cpp", "c_sharp", "kotlin", "python", "java", "go", "rust",
        "bash", "json", "yaml", "toml", "sql", "dockerfile",
        "diff", "xml", "ini", "regex", "gitcommit", "gitignore",
        "markdown", "markdown_inline",
      }

      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, ensure_installed)

      if #missing > 0 then
        ts.install(missing)
      end
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
        sync_root_with_cwd = true,
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
      }
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown", -- подгружается только для markdown-файлов
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_forward_search_on_start = false
    end,
  },
  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
