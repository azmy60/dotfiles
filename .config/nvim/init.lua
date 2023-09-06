local o = vim.opt
local g = vim.g
local api = vim.api

o.guicursor = ""

o.nu = true
o.relativenumber = true

local tabstop = 4
o.tabstop = tabstop
o.softtabstop = tabstop
o.shiftwidth = tabstop

local function toggleTabStop()
    if tabstop == 4 then
        tabstop = 2
    else
        tabstop = 4
    end
    o.tabstop = tabstop
    o.softtabstop = tabstop
    o.shiftwidth = tabstop
end

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

g.mapleader = " "

--vim.api.nvim_set_hl(0, "SignColumn", {})
--vim.api.nvim_set_hl(0, "ColorColumn", {bg="#333333"})

-- disable netrw for nvim.tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

o.termguicolors = true

-- conjure
g.maplocalleader = ","

-- System clipboard
vim.cmd("set clipboard+=unnamedplus")

if vim.fn.has("wsl") then
    vim.cmd([[
        let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            \   },
            \   'cache_enabled': 0,
            \ }
    ]])
end

require("plugins")
require("setup_plugins")
require("lsp")
require("snippets")
require("theme")
require('explorer')
require('git')
require('mappings')
