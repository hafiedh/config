return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- render headings, code blocks, tables, checkboxes, etc. in-buffer
    heading = { enabled = true },
    code = { style = "full" },
    checkbox = { enabled = true },
  },
  keys = {
    {
      "<leader>mp",
      "<cmd>RenderMarkdown buf_toggle<cr>",
      ft = "markdown",
      desc = "Toggle Markdown Preview (raw/rendered)",
    },
  },
}
