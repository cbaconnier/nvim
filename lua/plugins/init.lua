return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- format on save
    opts = require "configs.conform",
  },

  {
    'numToStr/Comment.nvim',
    opts = {
      pre_hook = function(ctx)
        -- "blade" comments keep to be html. This force what I defined.
        return vim.bo.commentstring
      end,
      mappings = {
        basic = true,
        extra = true,
        extended = {
          above = 'gcO',
          below = 'gco',
          eol = 'gcA',
        },
      },
    },
    lazy = false,
  },

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
          'windwp/nvim-ts-autotag',
          'RRethy/nvim-treesitter-endwise',
          'nvim-treesitter/nvim-treesitter-textobjects',
          'nvim-treesitter/nvim-treesitter-context',
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

      highlight = { enable = true },
      indent = { enable = true },
      -- incremental_selection = {
      --   enable = true,
      --   keymaps = { -- set to `false` to disable one of the mappings
      --     init_selection = 'gnn',
      --     node_incremental = 'grn',
      --     scope_incremental = 'grc',
      --     node_decremental = 'grm',
      --   },
      -- },
      autotag = { -- 'windwp/nvim-ts-autotag'
        enable = false, -- this breaks dot repeating with `>`
      },
      endwise = { -- 'RRethy/nvim-treesitter-endwise',
        enable = true,
      },
      textobjects = { -- 'nvim-treesitter/nvim-treesitter-textobjects',
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['if'] = '@function.inner',
            ['af'] = '@function.outer',
            ['ic'] = '@class.inner',
            ['ac'] = '@class.outer',
            ['il'] = '@loop.inner',
            ['al'] = '@loop.outer',
            ['ia'] = '@parameter.inner',
            ['aa'] = '@parameter.outer',
          },
        },
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
  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = function(_, opts)
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       { name = "laravel" },
  --     })
  --   end,
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

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },


  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources or {}, {
        { name = "vim-dadbod-completion" },
        { name = "emoji" },
      })
    end,
  },
}
