---@type ChadrcConfig
local M = {}

local function get_current_theme()
  local file = io.open(os.getenv("HOME") .. "/.config/nvchad_theme_name", "r")

  if file then
    local theme = file:read("*all"):gsub("%s+", "")
    file:close()
    return theme
  end
  return "catppuccin"
end

M.base46 = {
  theme = get_current_theme(),
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
  },
}

return M
