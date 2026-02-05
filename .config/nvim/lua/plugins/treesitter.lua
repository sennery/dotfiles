return {
  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    dependencies = {},
    config = function()
      local parsers = {
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
        'dockerfile',
        'go',
      }

      local group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(args)
          local ts = require 'nvim-treesitter'
          local lang = vim.treesitter.language.get_lang(args.match)
          if not vim.list_contains(ts.get_installed(), lang) and vim.list_contains(parsers, lang) then
            ts.install(lang):wait(300000)
          end

          local bufnr = args.buf
          local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
          if not ok or not parser then
            return
          end
          pcall(vim.treesitter.start, bufnr)
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select_keymap = function(keys, query, desc)
        vim.keymap.set({ 'x', 'o' }, keys, function()
          require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
        end, { desc = desc or query })
      end
      select_keymap('af', '@function.outer')
      select_keymap('if', '@function.inner')
      select_keymap('ab', '@block.outer')
      select_keymap('ib', '@block.inner')
      select_keymap('ac', '@class.outer')
      select_keymap('ic', '@class.inner')
      select_keymap('as', '@scope')

      local move_keymap = function(keys, query, method, desc)
        local method_func = require('nvim-treesitter-textobjects.move')[method]
        vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
          method_func(query, 'textobjects')
        end, { desc = desc or method .. ' ' .. query })
      end
      move_keymap(']f', '@function.outer', 'goto_next_start')
      move_keymap('[f', '@function.outer', 'goto_previous_start')
      move_keymap(']F', '@function.outer', 'goto_next_end')
      move_keymap('[F', '@function.outer', 'goto_previous_end')
      move_keymap(']]', '@block.outer', 'goto_next_start')
      move_keymap('[[', '@block.outer', 'goto_previous_start')
      move_keymap('][', '@block.outer', 'goto_next_end')
      move_keymap('[]', '@block.outer', 'goto_previous_end')
      move_keymap(']c', '@class.outer', 'goto_next_start')
      move_keymap('[c', '@class.outer', 'goto_previous_start')
      move_keymap(']C', '@class.outer', 'goto_next_end')
      move_keymap('[C', '@class.outer', 'goto_previous_end')
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },

  {
    'windwp/nvim-ts-autotag',
    lazy = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function(_, opts)
      require('nvim-ts-autotag').setup(opts)
    end,
  },

  -- Join and split code blocks
  {
    'Wansmer/treesj',
    keys = {
      { '<leader>cm', ':TSJToggle<CR>', desc = 'Toggle [M]ultiline block' },
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup {}
    end,
  },
}
