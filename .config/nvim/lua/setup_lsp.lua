-- mason
--
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = { "sumneko_lua", "tailwindcss" }
}

-- lspconfig
--
vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client)
  if (client.name == "tsserver") then
    client.resolved_capabilities.document_formatting = false
  end

  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
  -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
  -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
  vim.keymap.set("n", "<leader>ft", vim.lsp.buf.formatting, { buffer = 0 })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = 0 })
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { buffer = 0 })
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { buffer = 0 })
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = 0 })

  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
  vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { buffer = 0 })
end

local lspconfig = require('lspconfig')

-- JS / JSX / TS / TSX
lspconfig.tsserver.setup {
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
}

-- Lua
lspconfig.sumneko_lua.setup {
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
lspconfig.tailwindcss.setup {}

-- Prisma ORM
lspconfig.prismals.setup {}
