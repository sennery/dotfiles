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
      picker = {
        layouts = {
          default = {
            layout = {
              box = 'horizontal',
              width = 0.8,
              min_width = 120,
              height = 0.9,
              {
                box = 'vertical',
                border = 'top',
                title = '{title} {live} {flags}',
                { win = 'input', height = 1, border = 'left' },
                { win = 'list', border = 'top' },
              },
              { win = 'preview', title = '{preview}', border = 'top', width = 0.5 },
            },
          },
        },
      },
    },
    config = function(_, plugin_opts)
      require('snacks').setup(plugin_opts)

      -- Fix for incorrect icons appearing in the picker
      Snacks.util.icon = function(name, cat, opts)
        opts = opts or {}
        opts.fallback = opts.fallback or {}
        local try = {
          function()
            if cat == 'directory' then
              return opts.fallback.dir or '󰉋 ', 'Directory'
            end
            local Icons = require 'nvim-web-devicons'
            if cat == 'filetype' then
              return Icons.get_icon_by_filetype(name, { default = false })
            elseif cat == 'file' then
              local ext = name:match '%.(%w+)$'
              -- use basename here <----------
              return Icons.get_icon(vim.fs.basename(name), ext, { default = false }) --[[@as string, string]]
            elseif cat == 'extension' then
              return Icons.get_icon(nil, name, { default = false }) --[[@as string, string]]
            end
          end,
        }
        for _, fn in ipairs(try) do
          local ret = { pcall(fn) }
          if ret[1] and ret[2] then
            return ret[2], ret[3]
          end
        end
        return opts.fallback.file or '󰈔 '
      end

      vim.keymap.set('n', '<leader><leader>', Snacks.picker.smart, { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>sp', Snacks.picker.pickers, { desc = '[S]earch [P]ickers Telescope' })
      vim.keymap.set('n', '<leader>sr', Snacks.picker.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>sh', Snacks.picker.help, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sd', Snacks.picker.diagnostics_buffer, { desc = '[S]earch [D]iagnostics in buffer' })
      vim.keymap.set('n', '<leader>sD', Snacks.picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>s.', Snacks.picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sb', Snacks.picker.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>/', Snacks.picker.grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>s/', function()
        Snacks.picker.lines { layout = { preset = 'ivy' } }
      end, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>sg', Snacks.picker.grep_buffers, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set({ 'n', 'x' }, '<leader>sw', Snacks.picker.grep_word, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>gb', Snacks.picker.git_branches, { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>sn', function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
