require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

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
