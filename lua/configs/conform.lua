local options = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },

  formatters_by_ft = {
    lua = { "stylua" },
    blade = { "prettier" },
    php = { "pint", "php_cs_fixer" },
    javascript = { "prettier" },
    json = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    nix = { "nixfmt" },
  },

  format_on_save = {
    timeout_ms = 1000,
  },
}

return options
