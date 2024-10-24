return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- https://github.com/siduck/dotfiles/blob/master/nvchad/lua/plugins/init.lua
  -- https://github.com/V13Axel/nvim-config/tree/master

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      dependencies = {
        {
          "windwp/nvim-ts-autotag",
          config = function()
            require("nvim-ts-autotag").setup()
          end,
        },
      },
      ensure_installed = {
        "bash",
        "blade",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "nix",
        "php",
        "php_only",
        "phpdoc",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },

      autotag = {
        enable = true,
      },
    },

    config = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      vim.filetype.add {
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- {
  --   "adalessa/laravel.nvim",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "tpope/vim-dotenv",
  --     "MunifTanjim/nui.nvim",
  --     -- "nvimtools/none-ls.nvim",
  --     "kevinhwang91/promise-async",
  --   },
  --   cmd = { "Sail", "Artisan", "Composer", "Npm", "Laravel" },
  --   keys = {
  --     { "<leader>rr", ":Laravel routes<cr>" },
  --   },
  --   event = { "VeryLazy" },
    -- opts = {
    --   lsp_server = "intelephense",
    --   features = { null_ls = { enable = false } },
    -- },
  --   config = true,
  -- },
  {
    'phpactor/phpactor',
    build = 'composer install --no-dev --optimize-autoloader',
    ft = 'php',
    keys = {
      { '<Leader>pm', ':PhpactorContextMenu<CR>' },
      { '<Leader>pn', ':PhpactorClassNew<CR>' },
    }
  },

  {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
    opts = {
        close_tag_on_complete = false, 
    },
  },

}
