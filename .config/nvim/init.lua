local o = vim.opt
local g = vim.g
local api = vim.api

o.guicursor = ""

o.nu = true
o.relativenumber = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.wrap = false
o.hlsearch = false
o.hidden = true
o.termguicolors = true
o.scrolloff = 8
o.colorcolumn = "80"
o.signcolumn = "yes"
o.updatetime = 100

-- lightline
o.showmode = false

o.completeopt = "menuone,noinsert,noselect"

-- System clipboard
local clip = "/mnt/c/Windows/System32/clip.exe"
if vim.fn.executable(clip) == 1 then
    local wslyank = api.nvim_create_augroup("WSLYank", { clear = true })
    api.nvim_create_autocmd("TextYankPost", {
        command = "if v:event.operator ==# 'y' | call system(\"/mnt/c/Windows/System32/clip.exe\", @0) | endif",
        group = wslyank,
    })
end

g.mapleader = " "

--vim.api.nvim_set_hl(0, "SignColumn", {})
--vim.api.nvim_set_hl(0, "ColorColumn", {bg="#333333"})

require("plugins")
require("setup_plugins")
require("lsp")
require("snippets")
require("theme")
require('explorer')
require('git')
require('mappings')
