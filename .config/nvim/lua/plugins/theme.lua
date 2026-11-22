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
    "f-person/auto-dark-mode.nvim",
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.g.catppuccin_flavour = "macchiato"
        vim.cmd.colorscheme "catppuccin"
      end,
      set_light_mode = function()
        vim.g.catppuccin_flavour = "latte"
        vim.cmd.colorscheme "catppuccin"
      end,
    },
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
