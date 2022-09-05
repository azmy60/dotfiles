local o = vim.opt

o.guicursor = ""

o.nu = true
o.relativenumber = true

o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.wrap = false
o.hlsearch = false
o.hidden = true
o.termguicolors = true
o.scrolloff = 8
o.colorcolumn = "80"
o.signcolumn = "yes"
o.updatetime = 300

-- lightline
o.showmode = false

--vim.api.nvim_set_hl(0, "SignColumn", {})
--vim.api.nvim_set_hl(0, "ColorColumn", {bg="#333333"})

require("plugins")
require("after.plugins")

