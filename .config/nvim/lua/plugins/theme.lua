return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
    },
    init = function()
      vim.cmd.colorscheme "catppuccin"	
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
