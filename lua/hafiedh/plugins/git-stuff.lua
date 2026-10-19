return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- modern look
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      preview_config = { border = "rounded" },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        -- Navigation (nav_hunk replaces deprecated next_hunk/prev_hunk)
        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next Hunk")
        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Previous Hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")

        map("v", "<leader>hs", function()
          gs.stage_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })
        end, "Stage Hunk")

        map("v", "<leader>hr", function()
          gs.reset_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })
        end, "Reset Hunk")

        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")

        -- Blame
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")

        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Line Blame")

        -- Diff
        map("n", "<leader>hd", gs.diffthis, "Diff This")

        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, "Diff This ~")

        -- Text object
        map(
          { "o", "x" },
          "ih",
          ":<C-U>Gitsigns select_hunk<CR>",
          "Gitsigns Select Hunk"
        )
      end,
    },
  },

  {
    "akinsho/git-conflict.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      require("git-conflict").setup({
        -- Modern usage: pass a mapping table instead of wiring <Plug>
        -- targets by hand. Keys are identical to before, but they are
        -- buffer-local and only active inside conflicted buffers.
        default_mappings = {
          ours = "<leader>hco",
          theirs = "<leader>hct",
          both = "<leader>hcb",
          none = "<leader>hc0",
          next = "<leader>hcn",
          prev = "<leader>hcp",
        },
        default_commands = true,

        -- Must stay false: the plugin's own diagnostic handling calls
        -- vim.diagnostic.disable(), which was removed in Neovim 0.12.
        disable_diagnostics = false,

        highlights = {
          incoming = "DiffAdd",
          current = "DiffText",
        },
      })

      -- List all conflicts in the repo in a quickfix window
      vim.keymap.set(
        "n",
        "<leader>hcl",
        "<cmd>GitConflictListQf<cr>",
        { desc = "List Conflicts in Quickfix" }
      )

      -- Notify and hide diagnostics in the conflicted buffer
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          vim.diagnostic.enable(false, { bufnr = buf })
          vim.notify("Conflict detected in " .. vim.api.nvim_buf_get_name(buf))
        end,
      })

      -- Restore diagnostics once conflicts are resolved
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictResolved",
        callback = function()
          vim.diagnostic.enable(true, { bufnr = vim.api.nvim_get_current_buf() })
        end,
      })
    end,
  },
}
