return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",

    opts = {
      suggestion = {
        enabled = false, -- Using blink.cmp / nvim-cmp
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
