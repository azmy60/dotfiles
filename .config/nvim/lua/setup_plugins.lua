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

-- Treesitter
--
require('nvim-treesitter.parsers').get_parser_configs().automad = {
  install_info = {
    url = 'https://github.com/automadcms/tree-sitter-automad',
    files = { 'src/parser.c' },
  },
}

require('nvim-treesitter.configs').setup {
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    indent = { enable = true },
}
require('ts_context_commentstring').setup {}
vim.g.skip_ts_context_commentstring_module = true

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
