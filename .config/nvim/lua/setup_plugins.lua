local o = vim.opt
local g = vim.g

o.completeopt = { "menu", "menuone", "noselect" }

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
require('telescope').setup {
  defaults = {
    path_display = { "smart" },
    file_ignore_patterns = { "node_modules" },
    layout_config = {
      horizontal = {
        preview_cutoff = 0,
      },
    },
  }
}
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
require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "css",
    "lua",
    "graphql",
    "html",
    "javascript",
    "php",
    "scss",
    "sql",
    "tsx",
    "typescript",
    "vue",
  },
  context_commentstring = { enable = true },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  indent = { enable = true },
}

require("nvim_comment").setup({
  hook = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end
})

-- Neogit
--
require('neogit').setup {}

-- see git changes in buffer
--
require('gitsigns').setup {}

-- Autotag (html) and Autopair (for brackets)
--
require('nvim-ts-autotag').setup {}
require('nvim-autopairs').setup {
  disable_filetype = { 'TelescopePrompt', 'vim' }
}

local null_ls = require("null-ls")

null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.formatting.prettier,
    },
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-m>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-;>", function() ui.nav_file(4) end)
