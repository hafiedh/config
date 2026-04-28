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

        -- JS / TS ecosystem
        javascript = { { "prettierd", "prettier", stop_after_first = true } },
        typescript = { { "prettierd", "prettier", stop_after_first = true } },
        javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
        typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
        json = { { "prettierd", "prettier", stop_after_first = true } },
        css = { { "prettierd", "prettier", stop_after_first = true } },
        scss = { { "prettierd", "prettier", stop_after_first = true } },
        html = { { "prettierd", "prettier", stop_after_first = true } },
        markdown = { { "prettierd", "prettier", stop_after_first = true } },

        -- Go (🔥 proper setup)
        go = { "gci", "gofumpt", "golines" },

        -- Others (keep only useful ones)
        yaml = { "yamlfix" },
        toml = { "taplo" },
        rust = { "rustfmt" },
      },

      ----------------------------------------------------------------------
      -- Dynamic gci config (auto detect go.mod)
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
    -- Auto format (Go only: includes import fix)
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        -- fix imports via gopls
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })

        -- format via conform
        conform.format({ async = false })
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
