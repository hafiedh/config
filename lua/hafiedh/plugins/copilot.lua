return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- disable ghost text (we use cmp)
        panel = { enabled = false },
        keymaps = {
          suggestion = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-/>",
          },
        },
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-4o",
    },
    keys = {
      { "<leader>ce", ":CopilotChatExplain<CR>",  mode = "v", desc = "Copilot Chat Explain" },
      { "<leader>cc", ":CopilotChat<CR>",         mode = "n", desc = "Copilot Chat" },
      { "<leader>cc", ":CopilotChat<CR>",         mode = "v", desc = "Copilot Chat" },
      { "<leader>co", ":CopilotChatOptimize<CR>", mode = "v", desc = "Copilot Chat Optimized" },
      { "<leader>cf", ":CopilotChatFix<CR>",      mode = "v", desc = "Copilot Chat Fix" },
      { "<leader>cd", ":CopilotChatDebug<CR>",    mode = "v", desc = "Copilot Chat Debug" },
      { "<leader>ct", ":CopilotChatTest<CR>",     mode = "v", desc = "Copilot Chat Test" },
      { "<leader>cm", ":CopilotChatModels<CR>",   mode = "n", desc = "Copilot Chat Models" },
      { "<leader>cC", ":CopilotChatClear<CR>",    mode = "n", desc = "Copilot Chat Clear" },
      { "<leader>cR", ":CopilotChatReset<CR>",    mode = "n", desc = "Copilot Chat Reset" },
    },
  },
}
