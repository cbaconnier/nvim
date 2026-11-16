-- Citations like (MORT ≈98%), (HOG ≈5%, ≈15%; see [[Link]]):
-- dimmed, and collapsed by default to a superscript counter (¹ ² ³ …) in
-- markdown buffers. <leader>dc toggles the collapse.
--
-- Self-contained: this spec is merged by lazy.nvim into the render-markdown
-- one, so deleting this file removes the feature entirely.

-- a parenthesised group holding a 2-6 letter book code right before ≈NN
local PATTERN = [[\v\([^()]*<\u{2,6} ≈\d[^()]*\)]]
local SUP = { [0] = "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹" }
local ns = vim.api.nvim_create_namespace("citations")
local cite_re = vim.regex(PATTERN)

local function set_hl()
  vim.api.nvim_set_hl(0, "Citation", { link = "Comment", default = true })
end

local function sup(n)
  return (tostring(n):gsub("%d", function(d)
    return SUP[tonumber(d)]
  end))
end

-- One extmark per citation: conceals the text and draws the number inline.
local function render_citations(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local n = 0
  for lnum = 0, vim.api.nvim_buf_line_count(buf) - 1 do
    local col = 0
    while true do
      local s, e = cite_re:match_line(buf, lnum, col)
      if not s then
        break
      end
      s, e = s + col, e + col
      n = n + 1
      vim.api.nvim_buf_set_extmark(buf, ns, lnum, s, {
        end_col = e,
        conceal = "",
        virt_text = { { sup(n), "Citation" } },
        virt_text_pos = "inline",
      })
      col = e
    end
  end
end

-- render-markdown sizes table columns when it renders, so make it re-render
-- once our markers are in place (cell_offset reads them)
local function refresh_render(buf)
  local api = package.loaded["render-markdown.api"]
  if api then
    pcall(api.render, { buf = buf })
  end
end

local function set_collapsed(buf, on)
  vim.b[buf].citation_hide = on or nil
  local group = vim.api.nvim_create_augroup("citations_" .. buf, { clear = true })
  if on then
    render_citations(buf)
    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
      group = group,
      buffer = buf,
      callback = function()
        render_citations(buf)
        refresh_render(buf)
      end,
    })
  else
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  end
  refresh_render(buf)
end

-- matchadd is per-window, hence the window-variable guard
local function dim_citations()
  if not vim.w.citation_match then
    vim.w.citation_match = vim.fn.matchadd("Citation", PATTERN, 20)
  end
end

local function attach(buf)
  dim_citations()
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = vim.api.nvim_create_augroup("citations_dim_" .. buf, { clear = true }),
    buffer = buf,
    callback = dim_citations,
  })
  set_collapsed(buf, true)
  vim.keymap.set("n", "<leader>dc", function()
    set_collapsed(buf, not vim.b[buf].citation_hide)
  end, { buffer = buf, desc = "Toggle citations" })
end

-- The buffer a markdown tree node belongs to: render-markdown only hands us
-- the node, and it may be rendering a window other than the current one.
local function node_buf(node)
  local root = node:tree():root():id()
  local cur = vim.api.nvim_get_current_buf()
  local bufs = { cur }
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if b ~= cur and vim.bo[b].filetype == "markdown" then
      bufs[#bufs + 1] = b
    end
  end
  for _, b in ipairs(bufs) do
    local parser = vim.treesitter.get_parser(b, "markdown", { error = false })
    for _, tree in ipairs(parser and parser:trees() or {}) do
      if tree:root():id() == root then
        return b
      end
    end
  end
end

-- render-markdown can't see our extmark conceal, so correct each table
-- cell's width: for each marker, its width minus the width of the hidden text
local function cell_offset(ctx)
  local buf = node_buf(ctx.node)
  if not buf then
    return 0
  end
  local sr, sc, er, ec = ctx.node:range()
  local offset = 0
  for _, m in ipairs(vim.api.nvim_buf_get_extmarks(buf, ns, { sr, sc }, { er, ec }, { details = true })) do
    local row, col, d = m[2], m[3], m[4]
    local hidden = vim.api.nvim_buf_get_text(buf, row, col, row, d.end_col, {})[1]
    offset = offset + vim.fn.strdisplaywidth(d.virt_text[1][1]) - vim.fn.strdisplaywidth(hidden)
  end
  return offset
end

return {
  "MeanderingProgrammer/render-markdown.nvim",
  init = function()
    set_hl()
    local group = vim.api.nvim_create_augroup("citations", { clear = true })
    -- :colorscheme clears user-defined highlight groups
    vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_hl })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "markdown",
      callback = function(ev)
        attach(ev.buf)
      end,
    })
  end,
  opts = {
    -- level 3 hides concealed text entirely, which drops the markers;
    -- 2 keeps them
    win_options = {
      conceallevel = { default = 2, rendered = 2 },
    },
    pipe_table = {
      -- with wrap on, a row whose measured text width differs from its
      -- cell_offset-adjusted width is treated as "not fitting" and replaced
      -- by raw virtual text, which shows the citations again
      wrap = false,
      cell_offset = cell_offset,
    },
  },
}
