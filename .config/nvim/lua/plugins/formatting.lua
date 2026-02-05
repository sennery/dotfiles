local function has_config_file(pattern)
  local prettier = vim.fn.glob(pattern, false, true)
  if not vim.tbl_isempty(prettier) then
    return true
  end
  return false
end

local prettier_format = { 'prettierd', 'prettier', stop_after_first = true }

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
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_format = 'fallback',
      -- },
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = prettier_format,
        typescript = prettier_format,
        javascriptreact = prettier_format,
        typescriptreact = prettier_format,
        vue = prettier_format,
        css = prettier_format,
        scss = prettier_format,
        html = prettier_format,
        json = prettier_format,
        yaml = prettier_format,
        markdown = prettier_format,
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
