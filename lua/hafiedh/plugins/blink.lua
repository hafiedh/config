return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        -- Manual popup trigger: when you'd rather use LSP/buffer completion
        -- instead of Copilot, dismiss the ghost text then open the popup.
        ["<M-\\>"] = {
          function()
            pcall(function()
              require("copilot.suggestion").dismiss()
            end)
            -- returns nil -> falls through to "show" below
          end,
          "show",
          "show_documentation",
          "hide_documentation",
        },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        -- Tab: accept Copilot ghost text if visible, else navigate popup, else normal Tab
        ["<Tab>"] = {
          function(cmp)
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.accept()
              return true
            end
          end,
          "select_next",
          "fallback",
        },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = { auto_show = false }, -- no popup; Copilot ghost text is used instead
        trigger = {
          show_on_keyword = false,
          show_on_trigger_character = false,
        },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = false }, -- Copilot provides ghost text
      },
      -- popup in `:` cmdline (no Copilot there), inherits the keymap above
      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
}
