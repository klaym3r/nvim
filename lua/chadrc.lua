---@type ChadrcConfig
local M = {}

local function get_current_theme()
  local file_path = os.getenv("HOME") .. "/.config/hypr/theme_state"
  local file = io.open(file_path, "r")

  if file then
    local mode = file:read("*all"):gsub("%s+", "")
    file:close()
    if mode == "light" then
      return "catppuccin"
    end
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
