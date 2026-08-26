-- Mirrors kitty's built-in default color scheme (kitty.conf has no color
-- overrides, so these are kitty's actual defaults straight from its source).
local M = {}

-- kitty's default 16 ANSI colors + fg/bg
local black = "#000000" -- color0 / background
local red = "#cc0403" -- color1
local green = "#19cb00" -- color2
local yellow = "#cecb00" -- color3
local blue = "#0d73cc" -- color4
local magenta = "#cb1ed1" -- color5
local cyan = "#0dcdcd" -- color6
local white = "#dddddd" -- color7 / foreground
local br_black = "#767676" -- color8
local br_red = "#f2201f" -- color9
local br_green = "#23fd00" -- color10
local br_yellow = "#fffd00" -- color11
local br_blue = "#1a8fff" -- color12
local br_magenta = "#fd28ff" -- color13
local br_cyan = "#14ffff" -- color14
local br_white = "#ffffff" -- color15

M.base_30 = {
  white = white,
  darker_black = black,
  black = black, --  nvim bg
  black2 = "#1a1a1a",
  one_bg = "#1a1a1a",
  one_bg2 = "#262626",
  one_bg3 = "#303030",
  grey = "#444444",
  grey_fg = br_black,
  grey_fg2 = "#8a8a8a",
  light_grey = "#a8a8a8",
  red = red,
  baby_pink = br_red,
  pink = br_magenta,
  line = "#262626", -- for lines like vertsplit
  green = green,
  vibrant_green = br_green,
  blue = blue,
  nord_blue = br_blue,
  yellow = yellow,
  sun = br_yellow,
  purple = magenta,
  dark_purple = magenta, -- kitty only has one magenta
  teal = cyan,
  orange = br_red, -- kitty's default 16 colors have no true orange
  cyan = cyan,
  statusline_bg = black,
  lightbg = "#1a1a1a",
  pmenu_bg = br_red,
  folder_bg = blue,
}

M.base_16 = {
  base00 = black,
  base01 = "#1a1a1a",
  base02 = "#303030",
  base03 = br_black,
  base04 = "#a8a8a8",
  base05 = white,
  base06 = "#eeeeee",
  base07 = br_white,
  base08 = red,
  base09 = br_red,
  base0A = yellow,
  base0B = green,
  base0C = cyan,
  base0D = blue,
  base0E = magenta,
  base0F = br_red,
}

M.type = "dark"

M = require("base46").override_theme(M, "kitty")

return M
