---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "kitty",
  transparency = true,
  hl_add = {
    -- Блоки ```lang```: нейтральный фон-цвет с priority 90, поверх которого
    -- инъекции языка кладут свою подсветку (priority 100). Без этого блок
    -- целиком красился бы цветом @markup.raw.
    ["@markup.raw.block"] = { fg = "white" },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
  },
}

return M
