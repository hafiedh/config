return {
  -- LSP CONFIG
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Keymaps for LSP
      local keymap = vim.keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          opts.desc = "Show LSP references";        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
          opts.desc = "Go to declaration";          keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          opts.desc = "Show LSP definitions";       keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
          opts.desc = "Show LSP implementations";   keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
          opts.desc = "Show LSP type definitions";  keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
          opts.desc = "See available code actions"; keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          opts.desc = "Smart rename";               keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          opts.desc = "Show buffer diagnostics";    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
          opts.desc = "Show line diagnostics";      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          opts.desc = "Go to previous diagnostic";  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          opts.desc = "Go to next diagnostic";      keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          opts.desc = "Show documentation";         keymap.set("n", "K", vim.lsp.buf.hover, opts)
          opts.desc = "Restart LSP";                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        end,
      })

      -- Common on_attach
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        if client.server_capabilities then
          client.server_capabilities.documentFormattingProvider = true
        end
      end

      local util = require("lspconfig.util")

      -- Diagnostic symbols
      local signs = {
        [vim.diagnostic.severity.ERROR] = "X",
        [vim.diagnostic.severity.WARN]  = "!",
        [vim.diagnostic.severity.HINT]  = "?",
        [vim.diagnostic.severity.INFO]  = "i",
      }

      vim.diagnostic.config({
        signs = { text = signs },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })

      -- LSP Servers
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end,
        cmd = { "gopls", "-remote=auto" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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

      lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        settings = { completions = { completeFunctionCalls = true } },
        init_options = { preferences = { importModuleSpecifierPreference = "non-relative", quotePreference = "single" } },
      })
      lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.dockerls.setup({ capabilities = capabilities, on_attach = on_attach })
    end,
  },
}
