-- Laravel: Pint on save, the official Laravel language server, Blade highlighting.

-- Composer's global home is ~/.config/composer or ~/.composer depending on the machine.
local function laravel_lsp_cmd()
  for _, path in ipairs({ "~/.config/composer/vendor/bin/laravel-lsp", "~/.composer/vendor/bin/laravel-lsp" }) do
    local full = vim.fn.expand(path)
    if vim.fn.executable(full) == 1 then
      return full
    end
  end
  return "laravel-lsp"
end

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.php = { "pint" }
      opts.formatters = opts.formatters or {}
      opts.formatters.pint = {
        cwd = require("conform.util").root_file({ "pint.json", "composer.json" }),
      }
    end,
  },
  {
    -- phpcs falls back to a non-Laravel standard when a project has no ruleset.
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.php = {}
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- composer global require laravel/lsp; only starts in folders with an artisan file.
        laravel_lsp = {
          mason = false,
          cmd = { laravel_lsp_cmd() },
          init_options = { phpEnvironment = "herd", memoryLimit = "1G" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade", "php_only", "html" } },
  },
}
