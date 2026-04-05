return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      -- signs = {
      --   add = { text = '▎' },
      --   change = { text = '▎' },
      --   delete = { text = '' },
      --   topdelete = { text = '' },
      --   changedelete = { text = '▎' },
      --   untracked = { text = '▎' },
      -- },

      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']h', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next [H]unk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[h', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Prev [H]unk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [S]tage' })

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[H]unk [R]eset' })

        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
        map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = '[H]unk Preview [I]nline' })

        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, { desc = '[H]unk [B]lame ' })

        map('n', '<leader>hd', gitsigns.diffthis, { desc = '[H]unk [D]iff' })

        map('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end, { desc = '[H]unk [D]iff [~]' })

        map('n', '<leader>hQ', function()
          gitsigns.setqflist 'all'
        end, { desc = '[H]unk Set [Q]uikfix List Global' })
        map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk Set [Q]uikfix List' })

        -- Toggles
        map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = '[G]it Toggle Line [B]lame' })
        map('n', '<leader>gw', gitsigns.toggle_word_diff, { desc = '[G]it Toggle [W]ord Diff' })

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = '[I]nside [H]unk' })
      end,
    },
  },

  -- Add git tools
  {
    'neogitorg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = '[G]it Neo[g]it Open' },
      { '<leader>gp', '<cmd>Neogit pull<cr>', desc = '[G]it [P]ull' },
      { '<leader>gP', '<cmd>Neogit push<cr>', desc = '[G]it [P]ush' },
      { '<leader>gf', '<cmd>Neogit fetch<cr>', desc = '[G]it [F]etch' },
    },
    config = true,
  },
}
