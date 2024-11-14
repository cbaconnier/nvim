require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- inspect treesitter
map("n", "<leader>it", vim.treesitter.inspect_tree)
map("n", "<leader>i", vim.show_pos)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- Open buffer and use <c-d> to close them
local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
vim.keymap.set('n', '<C-e>', function()
  builtin.buffers({
    initial_mode = "normal",
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        end)
      end

      map('n', '<c-d>', delete_buf)

      return true
    end
  }, {
    sort_lastused = true,
    sort_mru = true,
    theme = "dropdown"
  })
end)
