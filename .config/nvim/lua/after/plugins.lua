local g = vim.g

g.mapleader = " "

g.moonflyTransparent = true
vim.cmd("colorscheme moonfly")

g.lightline = {
  colorscheme = "one",
}

-- Telescope
--
vim.keymap.set("n", "<C-P>", "<CMD>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>")

-- Nvim Tree
--
require("nvim-tree").setup({
  view = {
    side = "right"
  }
})
vim.keymap.set("n", "<C-B>", "<CMD>NvimTreeToggle<CR>")

-- Commenting
--
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }
}

require("nvim_comment").setup({
  hook = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end
})

-- Neogit
--
require('neogit').setup {}

-- LSP
--
vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client)
  if(client.name == "tsserver") then
    client.resolved_capabilities.document_formatting = false
  end
  
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
  -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
  -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
  vim.keymap.set("n", "<leader>ft", vim.lsp.buf.formatting, {buffer=0})
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer=0})
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {buffer=0})
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", {buffer=0})
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {buffer=0})
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {buffer=0})

  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
  vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, {buffer=0})
  vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, {buffer=0})
  vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", {buffer=0})
end

local lspconfig = require('lspconfig')

-- JS / JSX / TS / TSX
lspconfig.tsserver.setup {
  -- TODO learn what this capabilities for???
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

-- Emmet
lspconfig.emmet_ls.setup {}

-- TailwindCSS
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
}

-- Prisma ORM
lspconfig.prismals.setup{}

vim.opt.completeopt = {"menu", "menuone", "noselect"}

-- null-ls (for formatting)
--
local formatting = require("null-ls").builtins.formatting
require("null-ls").setup({
    sources = {
        formatting.prettierd,
    },
})

-- see git changes in buffer
--
require('gitsigns').setup{}

-- Autotag (html) and Autopair (for brackets)
--
require('nvim-ts-autotag').setup{}
require('nvim-autopairs').setup{
  disable_filetype = { 'TelescopePrompt', 'vim' }
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

