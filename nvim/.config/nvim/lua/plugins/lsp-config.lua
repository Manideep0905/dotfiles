return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities
                --settings = {
                --    format = { enable = false },
                --    --disable unused vars
                --    diagnostics = { ignoredCodes = { 6133 } }
                --}
            })
            lspconfig.tailwindcss.setup({
                capabilities = capabilities
            })
            lspconfig.html.setup({
                capabilities = capabilities
            })
            lspconfig.cssls.setup({
                capabilities = capabilities
            })
            lspconfig.jdtls.setup({
                capabilities = capabilities
            })
            --lspconfig.eslint.setup({
            --    capabilities = capabilities,

            --    settings = {
            --        rulesCustomizations = {
            --            -- Might conflict with prettier
            --            { rule = "@typescript-eslint/no-misused-promises", severity = "off" },
            --            { rule = "@typescript-eslint/no-unsafe-argument", severity = "off" },
            --            { rule = "@typescript-eslint/no-unsafe-assignment", severity = "off" },
            --            { rule = "import/defaults", severity = "off" },
            --            { rule = "import/extensions", severity = "off" },
            --            { rule = "import/namespace", severity = "off" },
            --            { rule = "import/no-cycle", severity = "off" },
            --            { rule = "import/no-unresolved", severity = "off" },

            --            -- Disable some rules that conflight with tsserver warnings
            --            {rule = "*no-unused-vars", severity = "off"}
            --        }
            --    },
            --    experimental = {}
            --})
            lspconfig.prismals.setup({
                capabilities = capabilities
            })
            lspconfig.yamlls.setup({
                capabilities = capabilities
            })
            lspconfig.bashls.setup({
                capabilities = capabilities
            })
            lspconfig.emmet_ls.setup({
                capabilities = capabilities,
                filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd"
                }
            })
            lspconfig.jsonls.setup({
                capabilities = capabilities
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic", -- or "strict"
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
            })


            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

        end
    }
}
