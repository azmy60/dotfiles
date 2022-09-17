local g = vim.g

g.mapleader = " "

g.moonflyTransparent = true
vim.cmd("colorscheme moonfly")

g.lightline = {
  colorscheme = "one",
}

-- smoothie
--
g.smoothie_speed_constant_factor = 20
g.smoothie_speed_linear_factor = 20
g.smoothie_speed_exponentiation_factor = 1.0

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

