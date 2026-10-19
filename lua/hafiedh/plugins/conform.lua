return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local conform = require("conform")

    ----------------------------------------------------------------------
    -- Setup
    ----------------------------------------------------------------------
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },

        -- JS / TS ecosystem (✅ FIXED)
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },

        -- Go
        go = { "gci", "gofumpt", "golines" },

        -- Others
        yaml = { "yamlfix" },
        toml = { "taplo" },
        rust = { "rustfmt" },
      },

      ----------------------------------------------------------------------
      -- Dynamic gci config
      ----------------------------------------------------------------------
      formatters = {
        gci = {
          args = function(ctx)
            local gomod = vim.fs.find("go.mod", {
              upward = true,
              path = ctx.filename,
            })[1]

            local module_name

            if gomod then
              for line in io.lines(gomod) do
                local m = line:match("^module%s+(.+)")
                if m then
                  module_name = m
                  break
                end
              end
            end

            module_name = module_name or ""

            return {
              "write",
              "--skip-generated",
              "-s", "standard",
              "-s", "default",
              "-s", "prefix(" .. module_name .. ")",
            }
          end,
        },
      },
    })

    ----------------------------------------------------------------------
    -- Auto organize/add imports on save (Go + TS/JS)
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.go", "*.ts", "*.tsx", "*.js", "*.jsx", "*.mts", "*.cts", "*.mjs", "*.cjs" },
      callback = function(args)
        local ft = vim.bo[args.buf].filetype

        if ft == "go" then
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
          conform.format({ async = false, bufnr = args.buf })
        else
          -- ts_ls: add missing imports, then sort/prune them
          vim.lsp.buf.code_action({
            context = { only = { "source.addMissingImports.ts" } },
            apply = true,
          })
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports.ts" } },
            apply = true,
          })
        end
      end,
    })

    ----------------------------------------------------------------------
    -- Manual format keymap
    ----------------------------------------------------------------------
    vim.keymap.set("n", "<leader>cf", function()
      conform.format()
    end, { desc = "[C]onform [F]ormat" })
  end,
}
