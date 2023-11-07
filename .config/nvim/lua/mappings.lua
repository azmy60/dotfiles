local telescope = require('telescope.builtin')
local used = ""
local function telescope_find_files()
  if used ~= "find_files" then
    used = "find_files"
    telescope.find_files()
  else
    telescope.resume()
  end
end
local function telescope_live_grep()
  if used ~= "live_grep" then
    used = "live_grep"
    telescope.live_grep()
  else
    telescope.resume()
  end
end
local function telescope_buffers()
  if used ~= "buffers" then
    used = "buffers"
    telescope.buffers()
  else
    telescope.resume()
  end
end

vim.keymap.set("n", "<C-P>", telescope_find_files)
vim.keymap.set("n", "<leader>fg", telescope_live_grep)
vim.keymap.set("n", "<leader>fb", telescope_buffers)

vim.keymap.set("n", "<C-B>", "<CMD>NvimTreeToggle<CR>")

local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", require('harpoon.mark').add_file)
vim.keymap.set("n", "<C-m>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-j>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-k>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-l>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-;>", function() ui.nav_file(4) end)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "dl", "d$")
vim.keymap.set("n", "dh", "d0")
vim.keymap.set("n", "cl", "c$")
vim.keymap.set("n", "ch", "c0")
