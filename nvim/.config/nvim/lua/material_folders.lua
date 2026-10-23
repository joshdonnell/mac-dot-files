-- Nerd Font folder glyphs for neo-tree, one colour (Starship pine) that reads in light and dark.
local M = {}

M.default_color = "#509475"
M.folder_closed = "󰉋"
M.folder_open = "󰝰"

function M.icon_for(_, opened)
  local glyph = opened and M.folder_open or M.folder_closed
  return glyph, M.default_color
end

return M
