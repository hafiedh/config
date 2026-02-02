return {
  {
    "neovim/nvim-lspconfig", -- boleh dihapus nanti, tapi aman disimpan
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local schemastore = require("schemastore")

      local capabilities = cmp_nvim_lsp.default_capabilities()

      ----------------------------------------------------------------------
      -- Keymaps (LspAttach-safe)
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
          keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
          keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          keymap.set("n", "K", vim.lsp.buf.hover, opts)
          keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
        end,
      })

      ----------------------------------------------------------------------
      -- Diagnostics (future-proof)
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
      -- Global on_attach
      ----------------------------------------------------------------------
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end

      ----------------------------------------------------------------------
      -- Helper: SAFE LSP STARTER (🔥 core fix)
      ----------------------------------------------------------------------
      local function start_lsp(name, config)
        config.capabilities = capabilities
        config.on_attach = on_attach

        vim.lsp.config[name] = config

        local patterns = config.filetypes or name
        if type(patterns) ~= "table" then
          patterns = { patterns }
        end

        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("LspStart_" .. name, { clear = true }),
          pattern = patterns,
          callback = function(args)
            vim.lsp.start(vim.lsp.config[name], { bufnr = args.buf })
          end,
        })
      end

      ----------------------------------------------------------------------
      -- Servers
      ----------------------------------------------------------------------
      start_lsp("lua_ls", {
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

      start_lsp("gopls", {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        cmd = { "gopls", "-remote=auto" },
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

      start_lsp("tsserver", {
        filetypes = {
          "typescript",
          "typescriptreact",
          "javascript",
          "javascriptreact",
        },
        cmd = { "typescript-language-server", "--stdio" },
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "non-relative",
            quotePreference = "single",
          },
        },
      })

      start_lsp("jsonls", {
        filetypes = { "json", "jsonc" },
        cmd = { "vscode-json-language-server", "--stdio" },
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      })

      start_lsp("pyright", {})
      start_lsp("dockerls", {})
      start_lsp("html", {})
      start_lsp("cssls", {})
    end,
  },
}
