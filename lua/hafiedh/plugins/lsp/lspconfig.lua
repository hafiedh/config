config = function()
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local schemastore = require("schemastore")

  local capabilities = cmp_nvim_lsp.default_capabilities()

  ----------------------------------------------------------------------
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
  -- on_attach (no formatting here, handled by conform.nvim)
  ----------------------------------------------------------------------
  local on_attach = function(_, _) end

  ----------------------------------------------------------------------
  -- SERVERS (NEW API)
  ----------------------------------------------------------------------

  -- Lua
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  })

  -- Go
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

  -- TypeScript
  vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- JSON
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

  -- YAML (with schemastore)
  vim.lsp.config("yamlls", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = schemastore.yaml.schemas(),
      },
    },
  })

  -- Others
  vim.lsp.config("pyright", { capabilities = capabilities, on_attach = on_attach })
  vim.lsp.config("dockerls", { capabilities = capabilities, on_attach = on_attach })
  vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })
  vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })

  ----------------------------------------------------------------------
  -- ENABLE SERVERS
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
  })
end
