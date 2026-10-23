-- Formatter and linter follow what the project uses:
--   formatting: oxfmt when node_modules/.bin/oxfmt exists, otherwise Prettier (needs a Prettier config)
--   linting: oxlint when the project has an oxlint config, ESLint when it has an ESLint config
-- Both linters fix on save.

local prettier_filetypes = {
  "css", "graphql", "handlebars", "html", "javascript", "javascriptreact", "json", "jsonc",
  "less", "markdown", "markdown.mdx", "scss", "typescript", "typescriptreact", "vue", "yaml",
}

local function project_has_bin(ctx, name)
  return vim.fs.find("node_modules/.bin/" .. name, { path = ctx.dirname, upward = true })[1] ~= nil
end

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      for _, ft in ipairs(prettier_filetypes) do
        local formatters = vim.tbl_filter(function(name)
          return name ~= "oxfmt"
        end, opts.formatters_by_ft[ft] or {})
        table.insert(formatters, 1, "oxfmt")
        formatters.stop_after_first = true
        opts.formatters_by_ft[ft] = formatters
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.oxfmt = {
        condition = function(_, ctx)
          return project_has_bin(ctx, "oxfmt")
        end,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Uses the project's node_modules/.bin/oxlint. lspconfig's own root_dir starts it in every project.
        oxlint = {
          mason = false,
          root_dir = function(bufnr, on_dir)
            local marker = vim.fs.find(
              { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts", "node_modules/.bin/oxlint" },
              { path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)), upward = true }
            )[1]
            if marker then
              on_dir(marker:match("^(.*)/node_modules/") or vim.fs.dirname(marker))
            end
          end,
        },
      },
      setup = {
        oxlint = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
              local client = vim.lsp.get_client_by_id(event.data.client_id)
              if not client or client.name ~= "oxlint" then
                return
              end
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = event.buf,
                callback = function()
                  if vim.g.autoformat == false or vim.b[event.buf].autoformat == false then
                    return
                  end
                  vim.lsp.buf.code_action({
                    context = { only = { "source.fixAll.oxc" }, diagnostics = {} },
                    apply = true,
                    filter = function(_, client_id)
                      return client_id == client.id
                    end,
                  })
                end,
              })
            end,
          })
        end,
      },
    },
  },
}
