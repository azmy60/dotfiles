-- Neogit
--
local neogit = require('neogit')
neogit.setup {}
vim.keymap.set("n", "<leader>g", function() neogit.open() end)

-- see git changes in buffer
--
require('gitsigns').setup {}
