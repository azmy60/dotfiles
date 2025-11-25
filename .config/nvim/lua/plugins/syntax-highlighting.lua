return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- LazyVim config for treesitter
    indent = { enable = true }, ---@type lazyvim.TSFeat
    folds = { enable = true }, ---@type lazyvim.TSFeat
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
    },
  }
}
