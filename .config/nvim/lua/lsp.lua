vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format {async = true}' ]]
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, buffer)
    -- if (client.name == "ts_ls") then
    --     client.server_capabilities.documentFormattingProvider = false
    -- end
    local keymap_opts = { buffer = buffer }

    -- vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)

    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "<leader>ft", function()
        vim.lsp.buf.format({
            async = true,
            buffer = 0,
        })
    end, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = 0 })
    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { buffer = 0 })
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { buffer = 0 })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = 0 })

    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { buffer = 0 })
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { buffer = 0 })
end

-- require("mason").setup()
-- require("mason-lspconfig").setup({
--     automatic_installation = true
-- })  

-- vim.lsp.config.some_language = {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         some_flag = true
--     },
-- }

local lspconfig = require('lspconfig')

-- -- JS / JSX / TS / TSX
lspconfig.ts_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Vue.js
lspconfig.vuels.setup {
    on_attach = on_attach,
}

-- CSS / SASS / LESS
lspconfig.cssls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- php
lspconfig.phpactor.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    }
}

-- Emmet
lspconfig.emmet_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "blade", "php" }
}

-- Lua
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },

            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
        },
    },
}

-- TailwindCSS
lspconfig.tailwindcss.setup {
    on_attach = on_attach,
}

-- Prisma ORM
lspconfig.prismals.setup {
    on_attach = on_attach,
}

-- Clojure
lspconfig.clojure_lsp.setup {
    on_attach = on_attach,
}

-- Rust
lspconfig.rust_analyzer.setup {}
local opts = {
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = false,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}
require('rust-tools').setup(opts)

-- Svelte
lspconfig.svelte.setup {
    on_attach = on_attach,
}

-- C/C++/Objective-C
lspconfig.ccls.setup {
    compilationDatabaseDirectory = "build",
}

lspconfig.unocss.setup {
    on_attach = on_attach,
    filetypes = { "html", "javascriptreact", "rescript", "typescriptreact", "vue", "svelte", "astro" },
}

lspconfig.astro.setup {
    on_attach = on_attach,
}

lspconfig.fennel_ls.setup {
    on_attach = on_attach,
}

-- Python
lspconfig.pylsp.setup {
    on_attach = on_attach,
}

-- Blade Formatter
vim.cmd [[ command! BladeFormatter execute "!blade-formatter --write %" | edit ]]

-- mason
require("mason").setup()
require("mason-lspconfig").setup()


