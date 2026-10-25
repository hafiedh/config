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
        -- Manual popup trigger in insert mode (Copilot ghost text stays visible).
        ["<M-\\>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        -- Tab: accept Copilot ghost text if visible, else normal Tab.
        -- Popup navigation is handled by arrow keys / <C-j>/<C-k>.
        ["<Tab>"] = {
          function(cmp)
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.accept()
              return true
            end
          end,
          "fallback",
        },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        -- Insert mode: auto popup + Copilot ghost text side by side.
        -- blink's own ghost text is disabled below so there's no doubled inline
        -- ghost text (two inline ghost texts at the cursor render concatenated).
        menu = { auto_show = true },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = false }, -- Copilot provides the only inline ghost text
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
