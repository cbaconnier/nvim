local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    blade = { "prettier" },
    php = { "pint", "php_cs_fixer" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    nix = { "nixfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
