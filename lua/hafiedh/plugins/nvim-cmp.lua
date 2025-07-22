
return {
  -- nvim-cmp main plugin
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",   -- source for text in buffer
      "hrsh7th/cmp-path",     -- source for file system paths
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",  -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
      {
        "zbirenbaum/copilot-cmp", -- Copilot CMP source
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
          require("copilot_cmp").setup()
        end,
      },
      {
        "CopilotC-Nvim/CopilotChat.nvim", -- Copilot Chat
        dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
        opts = {
          model = "gpt-4o", -- default model
          mappings = {
            complete = "<Tab>", -- ensure <Tab> triggers completion
          },
        },
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },       -- GitHub Copilot
          { name = "CopilotChat" },   -- CopilotChat tokens ($, @, #)
          { name = "nvim_lsp" },      -- LSP
          { name = "luasnip" },       -- snippets
          { name = "buffer" },        -- text within current buffer
          { name = "path" },          -- file system paths
        }),
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}
