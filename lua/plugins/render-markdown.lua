return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  opts = {
    -- obsidian.nvim already renders checkboxes/bullets; avoid the two clashing
    checkbox = { enabled = false },
    bullet = { enabled = false },
  },
}
