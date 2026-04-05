return {
  -- Useful utils
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
}
