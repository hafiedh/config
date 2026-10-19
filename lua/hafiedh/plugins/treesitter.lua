return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",

    dependencies = {
      "windwp/nvim-ts-autotag",
    },

    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- ============================================================
      -- Highlighting + indentation
      -- ============================================================

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.opt_local.indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- ============================================================
      -- Folding
      -- ============================================================

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.bo[args.buf].filetype == "yaml" then
            vim.opt_local.foldmethod = "manual"
            return
          end
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })

      -- ============================================================
      -- Incremental selection
      --   <C-Space> normal = start, visual = expand
      --   <BS>      visual = shrink
      -- ============================================================

      local stack = {}

      local function in_visual()
        local m = vim.fn.mode()
        return m == "v" or m == "V" or m == "\22"
      end

      local function select_node(node)
        local sr, sc, er, ec = node:range() -- end is exclusive
        if ec == 0 and er > sr then
          er = er - 1
          ec = #(vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1] or "")
        end
        if in_visual() then
          vim.cmd("normal! \27")
        end
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
      end

      -- Current visual selection as a 0-based, end-exclusive range
      local function visual_range()
        local a = vim.fn.getpos("v")
        local b = vim.fn.getpos(".")
        local sr, sc, er, ec = a[2] - 1, a[3] - 1, b[2] - 1, b[3] - 1
        if sr > er or (sr == er and sc > ec) then
          sr, sc, er, ec = er, ec, sr, sc
        end
        local line = vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1] or ""
        local ch = vim.fn.strcharpart(line:sub(ec + 1), 0, 1)
        return sr, sc, er, ec + math.max(#ch, 1)
      end

      local function get_root()
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok or not parser then
          return nil
        end
        return parser:parse()[1]:root()
      end

      local function start_selection()
        local node = vim.treesitter.get_node()
        if not node then
          vim.notify("Treesitter: no node", vim.log.levels.WARN)
          return
        end
        stack = { node }
        select_node(node)
      end

      local function expand_selection()
        local root = get_root()
        if not root then
          return
        end

        local sr, sc, er, ec = visual_range()
        local node = root:named_descendant_for_range(sr, sc, er, ec)

        -- climb until the node is strictly larger than the selection
        while node do
          local nsr, nsc, ner, nec = node:range()
          local same = nsr == sr and nsc == sc and ner == er and nec == ec
          local covers = (nsr < sr or (nsr == sr and nsc <= sc))
            and (ner > er or (ner == er and nec >= ec))
          if covers and not same then
            break
          end
          node = node:parent()
        end

        if node then
          table.insert(stack, node)
          select_node(node)
        end
      end

      local function shrink_selection()
        if #stack > 1 then
          table.remove(stack)
          select_node(stack[#stack])
        end
      end

      vim.keymap.set("n", "<C-Space>", start_selection,
        { desc = "Treesitter: Start Selection" })
      vim.keymap.set("x", "<C-Space>", expand_selection,
        { desc = "Treesitter: Expand Selection" })
      vim.keymap.set("x", "<BS>", shrink_selection,
        { desc = "Treesitter: Shrink Selection" })

      -- ============================================================
      -- Auto tag
      -- ============================================================

      require("nvim-ts-autotag").setup()
    end,
  },
}
