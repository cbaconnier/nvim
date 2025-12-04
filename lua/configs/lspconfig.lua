-- load defaults i.e lua_lsp
local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

local servers = {
  cssls = {},
  html = {
    filetypes = { "html", "blade", "typescriptreact" },
  },
  intelephense = {
    init_options = {
      globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
      licenceKey = os.getenv "HOME" .. "/.config/intelephense/licence.txt",
    },
    filetypes = { "php", "blade" },
  },
  nixd = {
    settings = {
      nixd = {
        formatting = {
          command = "nixpkgs-fmt",
        },
      },
    },
  },
  phpactor = {
    filetypes = { "php", "blade" },
    init_options = {
      ["language_server.diagnostics_on_update"] = false,
      ["language_server.diagnostics_on_open"] = false,
      ["language_server.diagnostics_on_save"] = false,
      ["language_server_phpstan.enabled"] = false,
      ["language_server_psalm.enabled"] = false,
    },
  },
  rust_analyzer = {},
  tailwindcss = {
    filetypes = { "html", "blade", "typescriptreact" },
  },
  ts_ls = {},
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and configs.on_attach then
      configs.on_attach(client, args.buf)
    end
  end,
})

-- Set global capabilities
vim.lsp.config("*", {
  capabilities = configs.capabilities,
})

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
