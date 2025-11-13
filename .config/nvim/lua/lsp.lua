vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, buffer)
    -- if (client.name == "ts_ls") then
    --     client.server_capabilities.documentFormattingProvider = false
    -- end
    local keymap_opts = { buffer = buffer }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)

    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "<leader>ft", function()
      vim.lsp.buf.format({
        async = true,
        buffer = 0,
      })
    end, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = 0 })
    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { buffer = 0 })
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { buffer = 0 })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = 0 })

    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { buffer = 0 })
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { buffer = 0 })
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { buffer = 0 })
  end
})

-- vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format {async = true}' ]]
-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- -- -- JS / JSX / TS / TSX
-- lspconfig.ts_ls.setup {
--     capabilities = capabilities,
--     on_attach = on_attach,
-- }

-- vim.lsp.config("vtsls", {
--   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
--   settings = {
--     vtsls = { tsserver = { globalPlugins = {} } },
--     typescript = {
--       inlayHints = {
--         parameterNames = { enabled = "literals" },
--         parameterTypes = { enabled = true },
--         variableTypes = { enabled = true },
--         propertyDeclarationTypes = { enabled = true },
--         functionLikeReturnTypes = { enabled = true },
--         enumMemberValues = { enabled = true },
--       },
--     },
--   },
--   before_init = function(_, config)
--     table.insert(config.settings.vtsls.tsserver.globalPlugins, {
--       name = "@vue/typescript-plugin",
--       location = vim.fn.expand(
--         "$MASON/packages/vue-language-server/node_modules/@vue/language-server"
--       ),
--       languages = { "vue" },
--       configNamespace = "typescript",
--       enableForWorkspaceTypeScriptVersions = true,
--     })
--   end,
--   -- capabilities = capabilities,
--   -- on_attach = on_attach,
-- })

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = {'package.json'},
          url = 'https://json.schemastore.org/package.json',
        },
        {
          fileMatch = { 'tsconfig.json' },
          url = 'https://json.schemastore.org/tsconfig.json',
        },
      },
    },
  },
})

-- vim.lsp.config('vtsls', {
--   -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
--   settings = {
--     vtsls = {
--       autoUseWorkspaceTsdk = true
--     },
--     ['js/ts'] = {
--       implicitProjectConfig = {
--         target = 'ESNext',
--       },
--     },
--     javascript = {
--       -- https://github.com/yioneko/vtsls/issues/169
--       tsdk = vim.fn.isdirectory(yarnTsdkPath) ~= 0 and yarnTsdkPath or nil,
--       format = {
--         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false
--       }
--     },
--     typescript = {
--       tsdk = vim.fn.isdirectory(yarnTsdkPath) ~= 0 and yarnTsdkPath or nil,
--       format = {
--         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false
--       }
--     }
--   }
-- })

-- Lua
vim.lsp.config('lua_ls', {
  -- on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },

      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
})

-- -- Rust
-- lspconfig.rust_analyzer.setup {}
-- local opts = {
--   tools = {
--     runnables = {
--       use_telescope = true,
--     },
--     inlay_hints = {
--       auto = false,
--       show_parameter_hints = false,
--       parameter_hints_prefix = "",
--       other_hints_prefix = "",
--     },
--   },
--
--   -- all the opts to send to nvim-lspconfig
--   -- these override the defaults set by rust-tools.nvim
--   -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
--   server = {
--     -- on_attach is a callback called when the language server attachs to the buffer
--     on_attach = on_attach,
--     settings = {
--       -- to enable rust-analyzer settings visit:
--       -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--       ["rust-analyzer"] = {
--         -- enable clippy on save
--         checkOnSave = {
--           command = "clippy",
--         },
--       },
--     },
--   },
-- }
-- require('rust-tools').setup(opts)

-- -- C/C++/Objective-C
-- lspconfig.ccls.setup {
--   compilationDatabaseDirectory = "build",
-- }

local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}

local vue_ls_config = {
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
      if #clients == 0 then
        vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
          local response = r and r.body
          -- TODO: handle error or response nil here, e.g. logging
          -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
          local response_data = { { id, response } }

          ---@diagnostic disable-next-line: param-type-mismatch
          client:notify('tsserver/response', response_data)
        end)
    end
  end,
}
vim.lsp.config('emmet_ls', {})
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.config('cssls', {})
vim.lsp.enable({"vtsls", "vue_ls", "emmet_ls", "cssls"})
