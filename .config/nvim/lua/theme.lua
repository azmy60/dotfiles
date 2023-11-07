-- vim.g.moonflyTransparent = true
-- vim.cmd.colorscheme "moonfly"

require('catppuccin').setup{
    -- flavour = 'latte',
    flavour  = 'macchiato',
    transparent_background = true,
}

vim.cmd.colorscheme "catppuccin"

-- vim.o.background = 'light'

vim.g.lightline = {
    colorscheme = "one",
}
