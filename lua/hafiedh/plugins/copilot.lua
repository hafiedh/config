return {
  {
    "github/copilot.vim",
    config = function()
      -- Copilot insert mode keymaps
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-.>", 'copilot#Accept("<CR>")', { expr = true, silent = true, noremap = true })
      vim.api.nvim_set_keymap("i", "<C-,>", 'copilot#Next()', { expr = true, silent = true, noremap = true })
      vim.api.nvim_set_keymap("i", "<C-/>", 'copilot#Previous()', { expr = true, silent = true, noremap = true })
      local keymap = vim.keymap
      -- CopilotChat normal mode keymaps
      keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>", { desc = "Copilot Chat" })
      keymap.set("n", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot Chat Explain" })
      keymap.set("n", "<leader>co", "<cmd>CopilotChatOptimize<CR>", { desc = "Copilot Chat Optimized" })
      keymap.set("n", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Copilot Chat Fix" })
      keymap.set("n", "<leader>cd", "<cmd>CopilotChatDebug<CR>", { desc = "Copilot Chat Debug" })
      keymap.set("n", "<leader>ct", "<cmd>CopilotChatTest<CR>", { desc = "Copilot Chat Test" })
      keymap.set("n", "<leader>cm", "<cmd>CopilotChatModels<CR>", { desc = "Copilot Chat Models" })
      keymap.set("n", "<leader>cC", "<cmd>CopilotChatClear<CR>", { desc = "Copilot Chat Clear" })
      keymap.set("n", "<leader>cR", "<cmd>CopilotChatReset<CR>", { desc = "Copilot Chat Reset" })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = {
        default = "gpt-4.1"
      },
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
