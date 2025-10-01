return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim",                   opts = {} },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local schemastore = require("schemastore")

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Keymap LSP
      local keymap = vim.keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          opts.desc = "Show LSP references"; keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
          opts.desc = "Go to declaration"; keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          opts.desc = "Show LSP definitions"; keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
          opts.desc = "Show LSP implementations"; keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
          opts.desc = "Show LSP type definitions"; keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
          opts.desc = "See available code actions"; keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          opts.desc = "Smart rename"; keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          opts.desc = "Show buffer diagnostics"; keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>",
            opts)
          opts.desc = "Show line diagnostics"; keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          opts.desc = "Go to previous diagnostic"; keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          opts.desc = "Go to next diagnostic"; keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          opts.desc = "Show documentation"; keymap.set("n", "K", vim.lsp.buf.hover, opts)
          opts.desc = "Restart LSP"; keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
        end,
      })

      -- Global on_attach
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end

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

      -- LSP Servers (all moved to vim.lsp.config)
      local servers = {
        lua_ls = {
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
        },
        gopls = {
          cmd = { "gopls", "-remote=auto" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = function(fname)
            return vim.fs.dirname(
              vim.fs.find({ "go.work", "go.mod", ".git" }, { upward = true, path = fname })[1]
            )
          end,
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        tsserver = {
          root_dir = function(fname)
            return vim.fs.dirname(
              vim.fs.find({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }, { upward = true, path = fname })
              [1]
            )
          end,
          filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          settings = { completions = { completeFunctionCalls = true } },
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "non-relative",
              quotePreference = "single",
            },
          },
        },
        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        pyright = {},
        dockerls = {},
        html = {},
        cssls = {},
      }

      -- Apply defaults and register autostart
      for name, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        vim.lsp.config[name] = config

        vim.api.nvim_create_autocmd("FileType", {
          pattern = config.filetypes or name,
          callback = function(args)
            vim.lsp.start(vim.lsp.config[name], { bufnr = args.buf })
          end,
        })
      end
    end,
  },
}
