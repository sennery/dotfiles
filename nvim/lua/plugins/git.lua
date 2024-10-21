return {
  -- adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
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
      { '<leader>gn', '<cmd>Neogit<cr>', desc = '[G]it [N]eogit Open' },
      { '<leader>gp', '<cmd>Neogit pull<cr>', desc = '[G]it [P]ull' },
      { '<leader>gP', '<cmd>Neogit push<cr>', desc = '[G]it [P]ush' },
      { '<leader>gf', '<cmd>Neogit fetch<cr>', desc = '[G]it [F]etch' },
    },
    config = true,
  },
}
