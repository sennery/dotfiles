return {
  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    lazy = false,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
      { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },
    },
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'css',
        'scss',
        'javascript',
        'typescript',
        'vue',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'python',
        'query',
        'regex',
        'toml',
        'tsx',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<TAB>',
          node_incremental = '<TAB>',
          node_decremental = '<bs>',
          scope_incremental = false,
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            -- ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
          },
        },
        -- swap = {
        --   enable = true,
        -- },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    lazy = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function(_, opts)
      require('nvim-ts-autotag').setup(opts)
    end,
  },
}
