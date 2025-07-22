return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")
    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    
    mason_lspconfig.setup({
      automatic_enable = false,
      -- list of servers for mason to install
      ensure_installed = {
        "html",
        "cssls",
        "gopls",
        "lua_ls",
        "pyright",
        "dockerls",
        "ts_ls",
        "jsonls",
        "yamlls",
      }
    })
    
    mason_tool_installer.setup({
      ensure_installed = {
        { 'golangci-lint', version = 'v2.0.2' },
        { 'gopls', condition = function() return not os.execute("go version") end },
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "gofumpt",
        "golines",
        "gomodifytags",
        "gotests",
        "yamlfmt",
      },
    })
  end,
}
