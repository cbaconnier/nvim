return {

  { import = "nvchad.blink.lazyspec" },

  {
    "saghen/blink.cmp",
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "moyiz/blink-emoji.nvim",
      "ricardoramirezr/blade-nav.nvim",
    },
    opts = {
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "php_declarations",
          "dadbod",
          "emoji",
          "blade-nav",
        },
        providers = {
          php_declarations = { module = "custom.blink-php", score_offset = 100 },
          dadbod = { module = "vim_dadbod_completion.blink" },
          emoji = { module = "blink-emoji", score_offset = -1 },
          ["blade-nav"] = {
            module = "blade-nav.blink",
            opts = {
              close_tag_on_complete = false,
            },
          },
        },
      },
      keymap = {
        -- preset = "default",
        -- ["<CR>"] = { "accept", "fallback" },
        -- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        -- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Tab>"] = {}, -- disable tab
        ["<S-Tab>"] = {}, --disable shift tab
      },
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
      },
    },
  },

  { "github/copilot.vim", lazy = false },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    opts = require "configs.conform",
  },

  {
    {
      "f-person/auto-dark-mode.nvim",
      config = function()
        local config = require "nvconfig"
        require("auto-dark-mode").setup {
          update_interval = 1000,
          set_dark_mode = function()
            if config.base46.theme ~= "chadtain" then
              config.base46.theme = "chadtain"
              require("base46").load_all_highlights()
            end
          end,
          set_light_mode = function()
            if config.base46.theme ~= "one_light" then
              config.base46.theme = "one_light"
              require("base46").load_all_highlights()
            end
          end,
        }

        require("auto-dark-mode").init()
      end,
    },
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("Comment").setup {
        pre_hook = function(ctx)
          -- ts_context_commentstring don't want to use blade comments for some reason
          if vim.bo.filetype == "blade" then
            return vim.bo.commentstring
          end

          return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
        end,
        mappings = {
          basic = true,
          extra = true,
          extended = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
          },
        },
      }
    end,
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
          "windwp/nvim-ts-autotag",
          "RRethy/nvim-treesitter-endwise",
          "nvim-treesitter/nvim-treesitter-textobjects",
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
        "rust",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      },

      highlight = { enable = true },
      indent = { enable = true },
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
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",
            ["ic"] = "@class.inner",
            ["ac"] = "@class.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
          },
        },
      },
    },

    config = function(plugin, opts)
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

  {
    "phpactor/phpactor",
    build = "composer install --no-dev --optimize-autoloader",
    ft = "php",
    keys = {
      { "<Leader>pm", ":PhpactorContextMenu<CR>" },
      { "<Leader>pn", ":PhpactorClassNew<CR>" },
    },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- -- image.nvim has slightly better performances with imagemagick through luarocks, but needs to be installed.
  -- -- For nix, we need `luajitPackages.magick`
  -- -- For arch, we need `sudo pacman -Syu imagemagick`
  -- -- For tmux, we need v>= 3.3 and configuration  `set -gq allow-passthrough on`, `set -g visual-activity off`
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1001, -- this plugin needs to run before anything else
  --   opts = {
  --     rocks = { "magick" },
  --   },
  -- },
  --
  {
    "3rd/image.nvim",
    event = {
      -- Load only when opening one of these file occur instead of using `lazy = false`
      "BufReadPost *.png,*.jpg,*.jpeg,*.gif,*.webp",
    },
    -- lazy = false,
    -- dependencies = { "luarocks.nvim" },
    config = function()
      require("image").setup {
        backend = "kitty",
        processor = "magick_rock",
        max_height_window_percentage = 50,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
      }
    end,
  },
}
