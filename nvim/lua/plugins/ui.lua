return {
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'nvim-lua/plenary.nvim', lazy = true },

  -- Experemental ui
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     lsp = {
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --         ['cmp.entry.get_documentation'] = true,
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       command_palette = true,
  --       long_message_to_split = true,
  --       inc_rename = true,
  --     },
  --     views = {
  --       cmdline_popup = {
  --         border = {
  --           -- style = 'none',
  --         },
  --       },
  --       cmdline_popupmenu = {
  --         win_options = {
  --           winhighlight = {
  --             Normal = 'NoicePopupmenu',
  --             FloatBorder = 'NoicePopupmenuBorder',
  --           },
  --         },
  --         border = {
  --           -- style = 'none',
  --         },
  --       },
  --     },
  --   },
  -- },

  -- File explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { '\\', ':Neotree toggle reveal<CR>', silent = true },
    },
    config = function()
      require('neo-tree').setup {
        default_component_configs = {
          name = {
            use_git_status_colors = true,
          },
          diagnostics = {
            highlights = {
              hint = 'DiagnosticHint',
              info = 'DiagnosticInfo',
              warn = 'DiagnosticWarn',
              error = 'DiagnosticError',
            },
          },
        },
        window = {
          width = 30,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
      }
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_show_tabline = false,
      },
      extensions = { 'oil', 'lazy', 'quickfix' },
      sections = {
        lualine_c = {
          { 'filename', path = 1 },
          {
            'navic',
            color_correction = 'static',
            padding = {
              left = 1,
              right = 0,
            },
          },
        },
        lualine_z = { 'location', 'searchcount' },
      },
    },
  },

  -- Tabs
  -- {
  --   'akinsho/bufferline.nvim',
  --   event = 'VeryLazy',
  --   keys = {
  --     { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle [P]in' },
  --     { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-[P]inned Buffers' },
  --     { '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete [O]ther Buffers' },
  --     { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the [R]ight' },
  --     { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the [L]eft' },
  --     { '<leader>bh', '<Cmd>BufferLinePick<CR>', desc = '[H]ighlight buffer picks' },
  --     { 'H', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
  --     { 'L', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
  --     { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev [B]uffer' },
  --     { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next [B]uffer' },
  --   },
  --   opts = {
  --     options = {
  --       -- stylua: ignore
  --       close_command = function(n)
  --         require('mini.bufremove').delete(n, false)
  --       end,
  --       -- stylua: ignore
  --       right_mouse_command = function(n)
  --         require("mini.bufremove").delete(n, false)
  --       end,
  --       diagnostics = 'nvim_lsp',
  --       diagnostics_indicator = function(count)
  --         return '(' .. count .. ')'
  --       end,
  --       always_show_bufferline = true,
  --       show_buffer_close_icons = false,
  --       offsets = {
  --         {
  --           filetype = 'neo-tree',
  --           text = '',
  --           highlight = 'Directory',
  --           text_align = 'left',
  --         },
  --       },
  --       hover = {
  --         enabled = true,
  --         delay = 200,
  --         reveal = { 'close' },
  --       },
  --       indicator = {
  --         style = 'icon',
  --       },
  --     },
  --   },
  --   config = function(_, opts)
  --     local bufferline = require 'bufferline'
  --     opts.options.style_preset = bufferline.style_preset.no_italic
  --     bufferline.setup(opts)
  --   end,
  -- },

  -- Show keybinds
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>b', group = '[B]uffers' },
        { '<leader>g', group = '[G]it' },
      }
    end,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[ ] Search Files' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })

      vim.keymap.set('n', '<leader>sf', function()
        builtin.find_files {
          no_ignore = true,
          hidden = true,
        }
      end, { desc = '[S]earch All [F]iles' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- File explorer
  {
    'stevearc/oil.nvim',
    keys = {
      { '<leader>o', ':Oil<CR>', silent = true, desc = 'Open [O]il' },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
