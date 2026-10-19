return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },

  config = function()
    local comment = require("Comment")
    local ts_context_commentstring =
      require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      pre_hook = function(ctx)
        local pre_hook = ts_context_commentstring.create_pre_hook()

        local result = pre_hook(ctx)

        -- Fallback to the filetype's default commentstring
        if not result or result == "" then
          return vim.bo.commentstring
        end

        return result
      end,
    })
  end,
}
