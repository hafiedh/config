return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    ----------------------------------------------------------------------
    -- Mason UI
    ----------------------------------------------------------------------
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    ----------------------------------------------------------------------
    -- LSP Servers
    ----------------------------------------------------------------------
    mason_lspconfig.setup({
      automatic_enable = false,
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
        "rust_analyzer",
        "taplo",
      },
    })

    ----------------------------------------------------------------------
    -- Tools (formatters, linters, etc)
    ----------------------------------------------------------------------
    mason_tool_installer.setup({
      ensure_installed = {
        { "golangci-lint", version = "v2.15.0" },

        -- formatters / linters
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",

        -- go tools
        "gci", -- ✅ import formatter
        "gofumpt",
        "golines",
        "gomodifytags",
        "gotests",

        -- misc
        "yamlfmt",
        "yamlfix", -- used by conform for yaml/yml
        "jsonlint",
      },
    })
  end,
}
