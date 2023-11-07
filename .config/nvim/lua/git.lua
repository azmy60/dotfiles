-- Neogit
--
local neogit = require('neogit')
neogit.setup {}
vim.keymap.set("n", "<leader>g", function() neogit.open() end)

local Color = require("neogit.lib.color").Color
vim.api.nvim_set_hl(0, "NeogitDiffContext", { bg = "None" })
vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { bg = "None" })
vim.api.nvim_set_hl(0, "NeogitDiffAdd",
    { bg = "#181926", fg = vim.api.nvim_get_hl(0, { name = "String" })['fg'] })
vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight",
    { bg = "#181926", fg = vim.api.nvim_get_hl(0, { name = "String" })['fg'] })
vim.api.nvim_set_hl(0, "NeogitDiffDelete",
    { bg = "#181926", fg = vim.api.nvim_get_hl(0, { name = "Error" })['fg'] })
vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight",
    { bg = "#181926", fg = vim.api.nvim_get_hl(0, { name = "Error" })['fg'] })
vim.api.nvim_set_hl(0, "NeogitHunkHeader", { bg = "#1e2030" })
vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { bg = "#24273a" })

-- see git changes in buffer
--
require('gitsigns').setup {}
