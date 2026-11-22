return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- flavour = 'latte',
      flavour = 'frappe',
      transparent_background = true,
    },
    init = function()
      vim.cmd.colorscheme "catppuccin-nvim"
    end,
  },
  {
    'itchyny/lightline.vim',
    init = function()
      vim.opt.showmode = false
      vim.g.lighline = {
        colorscheme = "one",
      }
    end,
  },
}
