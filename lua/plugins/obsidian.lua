return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  cmd = "Obsidian",
  dependencies = { "nvim-telescope/telescope.nvim" },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    note_id_func = function(title)
      return title
    end,

    workspaces = {
      {
        name = "main",
        path = "~/Documents/obsidian",
      },
    },

    picker = {
      name = "telescope.nvim",
    },

    daily_notes = {
      folder = "daily",
      date_format = "YYYY-MM-DD",
      workdays_only = false,
      template = "daily.md",
    },

    templates = {
      folder = "templates",
    },

    checkbox = {
      order = { " ", "x" },
    },
  },
}
