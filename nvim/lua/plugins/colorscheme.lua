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
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          FloatBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },

          NoiceCmdlinePopupBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          NoiceCmdlinePopupTitle = { fg = theme.ui.special, bg = theme.ui.bg_p1 },
          NoiceCmdlinePopup = { fg = theme.ui.special, bg = theme.ui.bg_p1 },
          NoiceCmdlineIcon = { fg = theme.ui.special, bg = theme.ui.bg_p1 },
          NoicePopupmenuBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          NoicePopupmenu = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          NoiceConfirmBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          NoiceConfirm = { fg = theme.ui.special, bg = theme.ui.bg_p1 },

          NeoTreeWinSeparator = { fg = theme.ui.bg_gutter, bg = theme.ui.bg_gutter },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'kanagawa-dragon'
    end,
  },
}
