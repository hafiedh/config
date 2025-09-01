return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilterCurrentFile",
    "LazyGitFilterCurrentDir",
    "LazyGitFilter"
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  key = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },

  },
}
