local M = {}

M.dark = "chadtain"
M.light = "one_light"

local theme_file = vim.fn.expand "~/.cache/.current_theme"

function M.from_system()
  local f = io.open(theme_file, "r")
  if not f then
    return M.dark
  end
  local content = vim.trim(f:read "*l")
  f:close()
  return content == "light" and M.light or M.dark
end

function M.apply()
  local new_theme = M.from_system()
  local config = require "nvconfig"
  if config.base46.theme ~= new_theme then
    config.base46.theme = new_theme
    require("base46").load_all_highlights()
  end
end

return M
