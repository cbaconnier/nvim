local options = {
  formatters_by_ft = {
    lua = { "stylua" }, 
    blade = { "blade-formatter" },
    php = { "pint", "php_cs_fixer" },
    -- css = { "prettier" },
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
        "--config", ".prettierrc.json",
      },
    },
  },

}

return options
