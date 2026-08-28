return {
  -- You can easily change to a different colorscheme.
  {
    'rebelot/kanagawa.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      compile = true,
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Adjust the Pmenu highlight groups to match the colorscheme
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          -- Make the floating window borderless
          FloatBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },

          -- Make the Telescope window borderless
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          -- Adjust the colors of snacks.nvim picker to match the colorscheme
          SnacksPickerInput = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
          SnacksPickerList = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          SnacksPickerPreview = { fg = theme.ui.fg, bg = theme.ui.bg_dim },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
}
