return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      "b0o/schemastore.nvim",
    "Saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    local schemastore = require("schemastore")

    local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- Keymaps (LspAttach)
      ----------------------------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          local keymap = vim.keymap

          keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
          keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
          keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
          keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
            buffer = ev.buf,
            silent = true,
            desc = "LSP Rename",
          })

          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          keymap.set("n", "K", vim.lsp.buf.hover, opts)
          keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
        end,
      })

      ----------------------------------------------------------------------
      -- Diagnostics
      ----------------------------------------------------------------------
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "X",
            [vim.diagnostic.severity.WARN]  = "!",
            [vim.diagnostic.severity.HINT]  = "?",
            [vim.diagnostic.severity.INFO]  = "i",
          },
        },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })

      ----------------------------------------------------------------------
      -- on_attach
      ----------------------------------------------------------------------
      local on_attach = function(_, _) end

      ----------------------------------------------------------------------
      -- SERVERS
      ----------------------------------------------------------------------
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("gopls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          typescript = {
            format = {
              indentSize = 2,
              tabSize = 2,
              semicolons = "insert",
              insertSpaceAfterCommaDelimiter = true,
              insertSpaceAfterSemicolonInForStatements = true,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
              insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
              placeOpenBraceOnNewLineForFunctions = false,
              placeOpenBraceOnNewLineForControlBlocks = false,
            },
            suggest = {
              autoImports = true,
              includeCompletionsForModuleExports = true,
              completeFunctionCalls = true,
            },
            preferences = {
              importModuleSpecifier = "relative",
              quoteStyle = "single",
              includePackageJsonAutoImports = "on",
            },
          },
          javascript = {
            format = {
              indentSize = 2,
              tabSize = 2,
              semicolons = "insert",
              insertSpaceAfterCommaDelimiter = true,
              insertSpaceAfterSemicolonInForStatements = true,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
              insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
              placeOpenBraceOnNewLineForFunctions = false,
              placeOpenBraceOnNewLineForControlBlocks = false,
            },
            suggest = {
              autoImports = true,
              includeCompletionsForModuleExports = true,
              completeFunctionCalls = true,
            },
            preferences = {
              importModuleSpecifier = "relative",
              quoteStyle = "single",
              includePackageJsonAutoImports = "on",
            },
          },
        },
      })

      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = schemastore.yaml.schemas(),
          },
        },
      })

      vim.lsp.config("pyright", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.config("dockerls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
      vim.lsp.config("taplo", { capabilities = capabilities, on_attach = on_attach })

      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
            check = { command = "clippy" },
            imports = {
              granularity = { group = "module" },
              prefix = "self",
            },
          },
        },
      })

      ----------------------------------------------------------------------
      -- ENABLE
      ----------------------------------------------------------------------
      vim.lsp.enable({
        "lua_ls",
        "gopls",
        "ts_ls",
        "jsonls",
        "yamlls",
        "pyright",
        "dockerls",
        "html",
        "cssls",
        "rust_analyzer",
        "taplo",
      })
    end,
  },
}
