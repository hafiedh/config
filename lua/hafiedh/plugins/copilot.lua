return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",

    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- show ghost text while typing (VSCode-like)
        keymap = {
          accept = "<Tab>",
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
