-- load defaults i.e lua_lsp
local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

local servers = {
  cssls = {},
  html = {
    filetypes = { "html", "blade", "typescriptreact" },
  },
  -- intelephense = {
  --   init_options = {
  --     globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
  --     licenceKey = os.getenv "HOME" .. "/.config/intelephense/licence.txt",
  --   },
  --   filetypes = { "php", "blade" },
  -- },
  phpantom_lsp = {
    cmd = { "phpantom_lsp" },
    filetypes = { "php", "blade" },
    root_markers = { "composer.json", ".git" },
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

-- refresh the LSP diagnostic loclist on save (when open)
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
      vim.diagnostic.setloclist { open = false }
    end
  end,
})
