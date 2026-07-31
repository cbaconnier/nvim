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

-- Telescope live grep args
vim.keymap.set("n", "<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live grep with args" })

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

-- Obsidian keymaps
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian find note" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Obsidian search" })
vim.keymap.set("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Obsidian today's note" })
vim.keymap.set("n", "<leader>oD", function()
  vim.ui.input({ prompt = "Date (YYYY-MM-DD): " }, function(input)
    if input and input ~= "" then
      vim.cmd("Obsidian today " .. input)
    end
  end)
end, { desc = "Obsidian note for date" })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "Obsidian new note" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "Obsidian insert template" })
vim.keymap.set("n", "<leader>oe", function()
  require("nvim-tree.api").tree.open { path = vim.fn.expand "~/Documents/obsidian" }
end, { desc = "Obsidian file explorer" })

-- Remove default new buffer keymap
vim.keymap.del("n", "<leader>b")

-- Buffer keymaps
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and not vim.bo[buf].modified then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = "Close all buffers except current" })

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
