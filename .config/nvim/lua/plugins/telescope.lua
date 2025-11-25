return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.1.9',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
    },
  },
  config = function()
    require("telescope").setup({
      path_display = { "smart" },
      file_ignore_patterns = { "node_modules" },
      defaults = {
        dynamic_preview_title = true,
        layout_config = {
          horizontal = {
            preview_cutoff = 0,
          },
          vertical = {
            preview_cutoff = 0,
          },
        },
      },
      pickers = {
      live_grep = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    additional_args = function(_)
                        return { "--hidden" }
                    end
                },
                find_files = {
                    file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                    hidden = true
                },
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
    })

    require("telescope").load_extension("fzf")

    local telescope = require('telescope.builtin')
    local used = ""
    local function telescope_find_files()
      if used ~= "find_files" then
        used = "find_files"
        telescope.find_files()
      else
        telescope.resume()
      end
    end
    local function telescope_live_grep()
      if used ~= "live_grep" then
        used = "live_grep"
        telescope.live_grep()
      else
        telescope.resume()
      end
    end
    local function telescope_buffers()
      if used ~= "buffers" then
        used = "buffers"
        telescope.buffers()
      else
        telescope.resume()
      end
    end

    vim.keymap.set("n", "<C-P>", telescope_find_files)
    vim.keymap.set("n", "<leader>fg", telescope_live_grep)
    vim.keymap.set("n", "<leader>fb", telescope_buffers)
  end,
}
