require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

o.swapfile = false
o.undofile = true
o.autowriteall = true

o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99

local theme = require "custom.utils.theme"
local theme_watcher = vim.uv.new_fs_poll()
theme_watcher:start(
  vim.fn.expand "~/.cache/.current_theme",
  200,
  vim.schedule_wrap(function(err)
    if not err then
      theme.apply()
    end
  end)
)

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    theme_watcher:stop()
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  callback = function(ev)
    if vim.bo[ev.buf].modified and vim.bo[ev.buf].buftype == "" and vim.api.nvim_buf_get_name(ev.buf) ~= "" then
      vim.api.nvim_buf_call(ev.buf, function()
        vim.cmd "silent! write"
      end)
    end
  end,
})
