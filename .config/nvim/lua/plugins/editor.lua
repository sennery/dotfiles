return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- indent lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '▏',
        tab_char = '▏',
      },
      scope = {
        char = '▎',
        show_start = false,
        show_end = false,
      },
    },
  },

  -- Navite comments improvement
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Location line
  {
    'SmiteshP/nvim-navic',
    -- lazy = true,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = function()
      return {
        separator = '  ',
        highlight = true,
        depth_limit = 5,
        lazy_update_context = true,
      }
    end,
  },
}
