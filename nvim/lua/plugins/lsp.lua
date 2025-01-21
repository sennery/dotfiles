return {
  -- LSP for lua files
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {},
  },

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- JSON and YAML schema support
      'b0o/schemastore.nvim',
    },
    config = function()
      -- vim.lsp.set_log_level 'debug'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- capabilities.workspace = {
      --   didChangeWatchedFiles = {
      --     dynamicRegistration = true,
      --   },
      -- }

      local lspconfig = require 'lspconfig'

      local function get_typescript_server_path(root_dir)
        local global_ts = vim.fn.expand '$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/lib/node_modules/typescript/lib'
        local project_ts = ''
        local function check_dir(path)
          project_ts = table.concat { path, 'node_modules', 'typescript', 'lib' }
          if vim.loop.fs_stat(project_ts) then
            return path
          end
        end
        if lspconfig.util.search_ancestors(root_dir, check_dir) then
          return project_ts
        else
          return global_ts
        end
      end

      require('mason').setup()
      local mason_registry = require 'mason-registry'
      local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

      local servers = {
        ts_ls = {
          filetypes = {
            'typescript',
            'javascript',
            'javascriptreact',
            'typescriptreact',
            'vue',
          },
          init_options = {
            plugins = {
              {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
              },
            },
          },
          on_new_config = function(new_config, new_root_dir)
            new_config.init_options.tsdk = get_typescript_server_path(new_root_dir)
          end,
          capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayVariableTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayParameterNameHints = 'literals', -- 'none' | 'literals' | 'all'
                includeInlayFunctionParameterTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
              },
            },
          },
        },
        volar = {
          capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            vue = {
              inlayHints = {
                inlineHandlerLeading = true,
                missingProps = true,
                optionsWrapper = true,
                vBindShorthand = true,
              },
            },
          },
        },

        cssls = {},
        html = {
          capabilities = {
            -- TODO: find wrapping attributes solution
            documentFormattingProvider = false,
          },
          settings = {
            html = {
              format = {
                indentInnerHtml = true,
                wrapAttributes = 'aligned-multiple',
              },
            },
          },
        },
        unocss = {},

        eslint = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        bashls = {},
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prettierd',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            lspconfig[server_name].setup(server)
          end,
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'
          -- Jump to the definition of the word under your cursor.
          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          -- Find references for the word under your cursor.
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          -- Jump to the implementation of the word under your cursor.
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
          -- Jump to the type of the word under your cursor.
          map('gT', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
          -- Fuzzy find all the symbols in your current document.
          map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          -- Fuzzy find all the symbols in your current workspace.
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- Rename the variable under your cursor.
          map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
          -- Execute a code action, usually your cursor needs to be on top of an error
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          local client = assert(vim.lsp.get_client_by_id(event.data.client_id), 'must have valid client')
          local settings = servers[client.name]
          if settings.capabilities then
            for k, v in pairs(settings.capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end

          if client.supports_method 'textDocument/documentHighlight' then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client.supports_method 'textDocument/documentSymbol' then
            require('nvim-navic').attach(client, event.buf)
          end

          if client.supports_method 'textDocument/inlayHint' then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay [H]ints')
          end

          if client.supports_method 'textDocument/codeLens' then
            map('<leader>cl', function()
              local lenses = vim.lsp.codelens.get(event.buf)
              vim.lsp.codelens.display(lenses, event.buf, event.data.client_id)
            end, 'Display [C]ode [L]enses')
          end
        end,
      })
    end,
  },
}
