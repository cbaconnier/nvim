vim.opt_local.conceallevel = 2

-- treat blockquotes like list items for wrap/indent purposes, so wrapped
-- continuation lines align past the `>` marker instead of under it
-- (needed for render-markdown.nvim's quote.repeat_linebreak to render
-- cleanly without win_options.showbreak, see
-- MeanderingProgrammer/render-markdown.nvim#561)
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = "list:-1"
vim.opt_local.formatlistpat:append [[\|^\s*>\s\+]]
