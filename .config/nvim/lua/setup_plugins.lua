local o = vim.opt

o.completeopt = { "menu", "menuone", "noselect" }

-- Telescope
--
require('telescope').setup {
    defaults = {
        path_display = { "smart" },
        file_ignore_patterns = { "node_modules" },
        layout_config = {
            horizontal = {
                preview_cutoff = 0,
            },
        },
    }
}

require 'nvim-treesitter.configs'.setup {
    auto_install = true,
    context_commentstring = { enable = true },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = { enable = true },
}

-- Commenting
--
require("nvim_comment").setup({
    hook = function()
        require("ts_context_commentstring.internal").update_commentstring()
    end
})

-- Autotag (html) and Autopair (for brackets)
--
require('nvim-ts-autotag').setup {}
require('nvim-autopairs').setup {
    disable_filetype = { 'TelescopePrompt', 'vim' }
}

local null_ls = require("null-ls")

null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.formatting.prettier,
    },
})
