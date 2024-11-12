local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    blade = { "blade-formatter", "prettier" },
    php = { "pint", "php_cs_fixer" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  formatters = {
    ["blade-formatter"] = {
      prepend_args = {
        "--write",
        "--config",
        ".prettierrc.json",
      },
    },
  },
}

return options
