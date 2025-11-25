return {
  {
    'milanglacier/minuet-ai.nvim',
    -- DO NOT add plenary as dependency like this
    -- see: https://github.com/milanglacier/minuet-ai.nvim/discussions/103#discussioncomment-13858974
    -- dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      provider = 'openai_fim_compatible',
      n_completions = 1, -- recommend for local model for resource saving
      -- I recommend beginning with a small context window size and incrementally
      -- expanding it, depending on your local computing power. A context window
      -- of 512, serves as an good starting point to estimate your computing
      -- power. Once you have a reliable estimate of your local computing power,
      -- you should adjust the context window to a larger value.
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          -- For Windows users, TERM may not be present in environment variables.
          -- Consider using APPDATA instead.
          api_key = 'TERM',
          name = 'Ollama',
          end_point = 'http://localhost:11434/v1/completions',
          model = 'qwen2.5-autocomplete',
          optional = {
            max_tokens = 6,
            -- top_p = 0.9,
          },
        },
      },
      virtualtext = {
        auto_trigger_ft={'lua', 'typescript', 'python', 'javascript', 'rust', 'vimscript', 'json', 'yaml', 'vue', 'scss', 'css', 'sh'},
        keymap = {
            -- accept whole completion
            accept = '<Tab>',
            -- accept_line = '<A-S-CR>',
          -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
        },
        show_on_completion_menu = true,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    -- event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "jcha0713/cmp-tw2css",
    },
    config = function()
      local cmp = require 'cmp'
      local compare = require('cmp.config.compare')
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.snippet.expand(args.body)
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources(
          {
            -- { name = 'minuet' },
            { name = 'nvim_lsp' },
            { name = 'calc' },
            { name = 'cmp-tw2css' },
            { name = 'cmp_ai' },
          },
          {
            { name = 'buffer' }
          }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
            { name = 'cmdline' },
          })
      })
    end,
  },
}
