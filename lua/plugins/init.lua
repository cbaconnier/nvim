return {

  { import = "nvchad.blink.lazyspec" },

  {
    "chrisbra/Recover.vim",
    event = "SwapExists",
  },

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
            module = "blade-nav.integrations.blink",
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
        -- ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
        -- ["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
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

  -- { "github/copilot.vim", lazy = false},
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          -- jump_prev = "<M-k>",
          -- jump_next = "<M-j>",
          -- accept = "<M-l>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = "<M-l>",
          next = "<M-k>",
          prev = "<M-j>",
          dismiss = "<C-h>",
        },
      },
      filetypes = {
        markdown = true, -- overrides default(disallow)
      },
      telemetry = {
        telemetryLevel = "off",
      },
    },
  },
  -- { "giuxtaposition/blink-cmp-copilot" },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    opts = require "configs.conform",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
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

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      renderer = {
        full_name = true,
      },
    },
  },

  { "nvim-treesitter/nvim-treesitter", enabled = false },
  {
    "romus204/tree-sitter-manager.nvim",
    lazy = false,
    config = function()
      require("tree-sitter-manager").setup {
        ensure_installed = {
          "bash",
          "blade",
          "caddy",
          "css",
          "dockerfile",
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
        auto_install = false,
        highlight = true,
      }

      vim.filetype.add {
        filename = {
          Caddyfile = "caddy",
        },
        pattern = {
          [".*%.blade%.php"] = "blade",
          ["%.env%.*"] = "sh",
          [".*%.caddy"] = "caddy",
        },
      }
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = { enable_close_on_slash = false },
      }
    end,
  },

  {
    "RRethy/nvim-treesitter-endwise",
  },

  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension "live_grep_args"
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

  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      image = {
        enabled = true,
        doc = {
          inline = true,
        },
        resolve = function(path, src)
          local ok, api = pcall(require, "obsidian.api")
          if ok and api.path_is_note(path) then
            return api.resolve_attachment_path(src)
          end
        end,
      },
    },
  },

  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  {
    "machakann/vim-sandwich",
    lazy = false,
    config = function() end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      default_amount = 2,
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "V13Axel/neotest-pest",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-pest",
        },
      }
    end,
  },
}
