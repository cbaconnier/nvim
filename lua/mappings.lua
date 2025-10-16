require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<S-p>", '"0p', { desc = "Paste from yank register" })
map("v", "<S-p>", '"0p', { desc = "Paste from yank register" })

-- inspect treesitter
map("n", "<leader>it", vim.treesitter.inspect_tree)
map("n", "<leader>i", vim.show_pos)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--

-- Copilot keymap
vim.api.nvim_set_keymap("i", "<C-a>", "<Plug>(copilot-suggest)", { silent = true })
vim.api.nvim_set_keymap("i", "<C-x>", "<Plug>(copilot-dismiss)", { silent = true })
vim.api.nvim_set_keymap("i", "<C-é>", "<Plug>(copilot-previous)", { silent = true })
vim.api.nvim_set_keymap("i", "<C-à>", "<Plug>(copilot-next)", { silent = true })

-- neotest keymap
vim.keymap.set("n", "<leader>tt", function()
  require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run file tests" })

vim.keymap.set("n", "<leader>to", function()
  require("neotest").output.open { enter = true }
end, { desc = "Open test output" })

vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })

-- Open buffer and use <c-d> to close them
local builtin = require "telescope.builtin"
local action_state = require "telescope.actions.state"
vim.keymap.set("n", "<C-e>", function()
  builtin.buffers({
    initial_mode = "normal",
    attach_mappings = function(prompt_bufnr, map)
      local delete_buf = function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
          vim.api.nvim_buf_delete(selection.bufnr, { force = true })
        end)
      end

      map("n", "<c-d>", delete_buf)

      return true
    end,
  }, {
    sort_lastused = true,
    sort_mru = true,
    theme = "dropdown",
  })
end)
