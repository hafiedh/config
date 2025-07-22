return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
  
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
  
        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
  
        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")
  
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
  
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
  
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
  
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
  
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff this ~")
  
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
        end,
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("git-conflict").setup({
        default_mappings = false,
        default_commands = true,
        disable_diagnostics = true,
        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })

      -- Autocommand for conflict detection
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
        end,
      })

      -- Custom keymaps using <leader>hc prefix
      vim.keymap.set("n", "<leader>hco", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
      vim.keymap.set("n", "<leader>hct", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
      vim.keymap.set("n", "<leader>hcb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
      vim.keymap.set("n", "<leader>hc0", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
      vim.keymap.set("n", "<leader>hcn", "<cmd>GitConflictNextConflict<cr>", { desc = "Next Conflict" })
      vim.keymap.set("n", "<leader>hcp", "<cmd>GitConflictPrevConflict<cr>", { desc = "Previous Conflict" })
      vim.keymap.set("n", "<leader>hcl", "<cmd>GitConflictListQf<cr>", { desc = "List Conflicts in Quickfix" })
    end,
  },
}
