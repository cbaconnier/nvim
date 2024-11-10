-- load defaults i.e lua_lsp
local configs = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

-- require("lspconfig.configs").laravel_dev_tools = {
--   default_config = {
--     cmd = { "/home/clement/.local/share/laravel-dev-tools/builds/laravel-dev-tools", "lsp"},
--     filetypes = { "blade", "php" },
--     root_dir = function(fname)
--       return lspconfig.util.find_git_ancestor(fname)
--     end;
--     settings = {},
--   },
-- }

local servers = {
  cssls = {},
  html = {
    filetypes = { "html", "blade" },
  },
  intelephense = {
    init_options = {
      globalStoragePath = os.getenv "HOME" .. "/.local/share/intelephense",
      licenceKey = "~/.config/intelephense/licence.txt",
    },
    filetypes = { "php", "blade" },
  },
  -- laravel_dev_tools = { },
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
    root_dir = function(fname)
      return lspconfig.util.find_git_ancestor(fname)
    end,
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
    filetypes = { "html", "blade" },
  },
  ts_ls = {},
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
