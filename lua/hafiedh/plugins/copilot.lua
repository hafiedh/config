return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",

    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- show ghost text while typing (VSCode-like)
        keymap = {
          accept = false, -- <Tab> is handled by blink.cmp (falls back to popup when no ghost text)
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },

      panel = {
        enabled = false,
      },

      filetypes = {
        markdown = true,
        gitcommit = true,
        yaml = true,
        help = false,
      },
    },
  },
}
