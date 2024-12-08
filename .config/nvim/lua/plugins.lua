vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'bluz71/vim-moonfly-colors'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        requires = 'nvim-lua/plenary.nvim'
    }
    use 'itchyny/lightline.vim'
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'neovim/nvim-lspconfig'
    }
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/nvim-cmp'
    use 'jcha0713/cmp-tw2css'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use "terrortylor/nvim-comment"
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    use { 'pantharshit00/vim-prisma' }
    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    }
    use { 'lewis6991/gitsigns.nvim' }
    use { 'windwp/nvim-ts-autotag' }
    use { 'windwp/nvim-autopairs' }
    use 'mfussenegger/nvim-dap'
    use 'ThePrimeagen/vim-be-good'
    use 'ThePrimeagen/harpoon'
    use 'APZelos/blamer.nvim'
    use("simrat39/rust-tools.nvim")
    use 'hrsh7th/cmp-cmdline'
    use 'stevearc/dressing.nvim'
    use {
        "Exafunction/codeium.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                virtual_text = {
                    enabled = true,
                },
            })
        end
    }
    use 'Olical/conjure'
    use {
        'laytan/tailwind-sorter.nvim',
        requires = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
        config = function() require('tailwind-sorter').setup() end,
        run = 'cd formatter && npm i && npm run build',
    }
    use { "catppuccin/nvim", as = "catppuccin" }
    use {
        "pmizio/typescript-tools.nvim",
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {}
        end,
    }
    use {
        "olrtg/nvim-emmet",
        config = function()
            vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
        end,
    }
end)
