local M = {}
local renderers = {}
local installed = false

local function setup_inline_size()
  local doc = require "snacks.image.doc"
  local latex = doc.transforms.latex
  doc.transforms.latex = function(img, ctx)
    local inline_math = img.ext == "math.tex"
      and ctx.content and ctx.content.node:type() == "inline_formula"
    if inline_math then
      local content = vim.trim(img.content or "")
      content = content:gsub("^%$", ""):gsub("%$$", "")
      content = content:gsub("^\\%(", ""):gsub("\\%)$", "")
      -- Общая высота и базовая линия для букв и индексов. Отдельный формат
      -- сохраняет невидимую mathstrut: обычный -trim снова её обрезал бы.
      img.content = "\\begin{math}\\displaystyle\\mathstrut " .. content .. "\\end{math}"
    end
    latex(img, ctx)
    if inline_math then
      img.ext = "math-inline.tex"
    end
  end

  local placement = require "snacks.image.placement"
  local state = placement.state
  placement.state = function(self)
    local ret = state(self)
    if self.opts.inline and self.img.src:match("%.math%-inline%.tex$") and ret.loc.height == 1 then
      -- Snacks делит уже округлённую ширину на число строк: длинные
      -- формулы становятся мельче коротких. Считаем по исходным пикселям.
      local cell = Snacks.image.terminal.size()
      local size = self.img.info.size
      local width = math.ceil(size.width / size.height * cell.cell_height / cell.cell_width)
      local limit = self.opts.max_width or vim.o.columns
      for _, win in ipairs(ret.wins) do
        local info = vim.fn.getwininfo(win)[1]
        limit = math.min(limit, info.width - info.textoff)
      end
      ret.loc.width = math.max(1, math.min(width, limit))
    end
    return ret
  end
end

function M.enabled(buf)
  return vim.bo[buf].filetype ~= "markdown" or vim.b[buf].math_preview == true
end

function M.window()
  if vim.bo.filetype == "markdown" then
    local enabled = M.enabled(0)
    vim.wo.conceallevel = enabled and 2 or 0
    vim.wo.concealcursor = enabled and "nv" or ""
  end
end

function M.toggle()
  local buf = vim.api.nvim_get_current_buf()
  vim.b[buf].math_preview = not M.enabled(buf)
  local renderer = renderers[buf]
  if renderer and not M.enabled(buf) then
    -- Удаляем также формулы за пределами экрана и незавершённые размещения,
    -- иначе они оставляют виртуальные строки до следующей прокрутки.
    for id, img in pairs(renderer.imgs) do
      if img.opts.type == "math" then
        img:close()
        renderer.imgs[id] = nil
      end
    end
    for id, img in pairs(renderer.idx) do
      if img.closed then
        renderer.idx[id] = nil
      end
    end
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, M.window)
  end
  -- Пересканировать формулы и убрать старые размещения через сам snacks.
  vim.api.nvim_exec_autocmds("BufWinEnter", { buffer = buf, modeline = false })
  vim.notify("LaTeX: " .. (M.enabled(buf) and "включён" or "выключен"))
end

function M.setup()
  if installed then
    return
  end
  installed = true
  setup_inline_size()
  -- У snacks нет API отключения формул для буфера. Запоминаем его renderer,
  -- чтобы закрывать все формулы, сохраняя обычные изображения.
  local inline = require "snacks.image.inline"
  local new = inline.new
  inline.new = function(buf)
    local renderer = new(buf)
    renderers[buf] = renderer
    return renderer
  end
  -- Предикат применяется только к формулам в queries/latex/images.scm.
  -- Картинки и схемы продолжают работать независимо от переключателя.
  vim.treesitter.query.add_predicate("math-preview?", function(_, _, buf)
    return type(buf) == "number" and M.enabled(buf)
  end, { force = true })
  local group = vim.api.nvim_create_augroup("MarkdownMathPreview", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = group,
    callback = M.window,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      renderers[ev.buf] = nil
    end,
  })
end

return M
