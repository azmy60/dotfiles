return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
