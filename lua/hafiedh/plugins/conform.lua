return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
        -- import conform plugin
        local conform = require("conform")

        -- configure conform
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                svelte = { { "prettierd", "prettier", stop_after_first = true } },
                astro = { { "prettierd", "prettier", stop_after_first = true } },
                javascript = { { "prettierd", "prettier", stop_after_first = true } },
                typescript = { { "prettierd", "prettier", stop_after_first = true } },
                javascriptreact = { { "prettierd", "prettier", stop_after_first = true } },
                typescriptreact = { { "prettierd", "prettier", stop_after_first = true } },
                json = { { "prettierd", "prettier", stop_after_first = true } },
                graphql = { { "prettierd", "prettier", stop_after_first = true } },
                java = { "google-java-format" },
                kotlin = { "ktlint" },
                ruby = { "standardrb" },
                markdown = { { "prettierd", "prettier", stop_after_first = true } },
                erb = { "htmlbeautifier" },
                html = { "htmlbeautifier" },
                bash = { "beautysh" },
                proto = { "buf" },
                rust = { "rustfmt" },
                yaml = { "yamlfix" },
                toml = { "taplo" },
                css = { { "prettierd", "prettier", stop_after_first = true } },
                scss = { { "prettierd", "prettier", stop_after_first = true } },
                sh = { "shellcheck" },
                go = { "gofmt" },
                xml = { "xmllint" },
            },
        })

        -- set keybinds
        vim.keymap.set("n", "<leader>cf", function()
            conform.format()
        end, { desc = "[C]onform [F]ormat" })
    end,
}