-- Ghostty palettes as base16: Osaka Jade when dark, Light Lite when light.
-- Neovim detects the terminal background, so this follows Ghostty's light/dark switch.

local palettes = {
  dark = {
    base00 = "#111c18", base01 = "#1d2e27", base02 = "#32473B", base03 = "#53685B",
    base04 = "#7A8B7F", base05 = "#C1C497", base06 = "#F7E8B2", base07 = "#F7E8B2",
    base08 = "#FF5345", base09 = "#db9f9c", base0A = "#E5C736", base0B = "#63b07a",
    base0C = "#2DD5B7", base0D = "#ACD4CF", base0E = "#D2689C", base0F = "#549e6a",
  },
  light = {
    base00 = "#ffffff", base01 = "#f5f5f5", base02 = "#dddddd", base03 = "#777777",
    base04 = "#555555", base05 = "#222222", base06 = "#111111", base07 = "#000000",
    base08 = "#e84135", base09 = "#d56e0c", base0A = "#b38600", base0B = "#34a853",
    base0C = "#129eaf", base0D = "#4285f4", base0E = "#a142f4", base0F = "#333333",
  },
}

local function apply()
  require("mini.base16").setup({ palette = palettes[vim.o.background] or palettes.dark })
  vim.g.colors_name = "ghostty-" .. vim.o.background
end

return {
  {
    "nvim-mini/mini.base16",
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        callback = function()
          vim.schedule(apply)
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = apply,
    },
  },
}
