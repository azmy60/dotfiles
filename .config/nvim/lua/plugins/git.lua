return {
  { 'lewis6991/gitsigns.nvim' }, 
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>g", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    },
    init = function()
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
    end,
  }
}
