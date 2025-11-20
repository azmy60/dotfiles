-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.guicursor = ""

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

local tabstop = 2

vim.opt.tabstop = tabstop
vim.opt.softtabstop = tabstop
vim.opt.shiftwidth = tabstop

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


vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 100
vim.opt.ignorecase = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.g.mapleader = " "

-- conjure
vim.g.maplocalleader = ","

-- System clipboard
vim.cmd("set clipboard+=unnamedplus")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "dl", "d$")
vim.keymap.set("n", "dh", "d0")
vim.keymap.set("n", "cl", "c$")
vim.keymap.set("n", "ch", "c0")

require("config.lazy")

require('nvim-treesitter.configs').setup {
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  indent = { enable = true },
}

require("lsp")

-- require('ts_context_commentstring').setup {}
-- vim.g.skip_ts_context_commentstring_module = true

local function ollama_run(model)
  if not model or model == "" then
    return
  end

  vim.fn.jobstart({
    "curl",
    "-s",
    "http://localhost:11434/api/run",
    "-d",
    string.format('{"model":"%s"}', model),
  }, {
      detach = true,
      on_exit = function()
        vim.schedule(function()
          vim.notify("Ollama model started: " .. model)
        end)
      end,
      -- ignore all stdout / stderr
      stdout_buffered = false,
      stderr_buffered = false,
    })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    ollama_run("qwen2.5-coder:7b")
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd("Minuet virtualtext enable")
    vim.cmd("Minuet cmp enable")
  end,
})

