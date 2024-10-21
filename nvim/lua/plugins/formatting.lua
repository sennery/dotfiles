local function has_config_file(pattern)
  local prettier = vim.fn.glob(pattern, false, true)
  if not vim.tbl_isempty(prettier) then
    return true
  end
  return false
end

return {
  -- Autoformat
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        vue = { 'prettierd', 'prettier', stop_after_first = true },
      },
      formatters = {
        prettierd = {
          condition = function()
            return has_config_file '.*prettier*'
          end,
        },
        prettier = {
          condition = function()
            return has_config_file '.*prettier*'
          end,
        },
      },
    },
  },
}
