vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>v', function()
  local config = vim.diagnostic.config()
  if config and config.virtual_lines then
    config.virtual_lines = false
    config.virtual_text = { current_line = true }
  else
    config.virtual_lines = true
    config.virtual_text = false
  end
  vim.diagnostic.config(config)
end, { desc = 'Toggle [V]irtual line diagnostic' })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Open terminal function
local function open_terminal()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.api.nvim_win_set_width(0, 50)
  vim.cmd.startinsert()
end
vim.keymap.set('n', '<leader>tt', open_terminal, { desc = 'Open [T]erminal' })
-- Open terminal and run command keymap
vim.keymap.set('n', '<leader>tn', function()
  open_terminal()
  vim.fn.chansend(vim.bo.channel, { 'npm run dev\r\n' })
  vim.cmd.stopinsert()
  vim.cmd.wincmd 'p'
end, { desc = 'Open [T]erminal and start [N]PM' })
