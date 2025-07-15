return {
  -- LSP for lua files
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
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

      require('mason').setup()
      local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'

      local servers = {
        vtsls = {
          filetypes = {
            'typescript',
            'javascript',
            'javascriptreact',
            'typescriptreact',
            'vue',
          },
          capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = '@vue/typescript-plugin',
                    location = vue_language_server_path,
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                  },
                },
              },
            },
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
        vue_ls = {
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
          on_init = function(client)
            client.handlers['tsserver/request'] = function(_, result, context)
              local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
              if #clients == 0 then
                vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
                return
              end
              local ts_client = clients[1]

              local param = unpack(result)
              local id, command, payload = unpack(param)
              ts_client:exec_cmd({
                title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                command = 'typescript.tsserverRequest',
                arguments = {
                  command,
                  payload,
                },
              }, { bufnr = context.bufnr }, function(_, r)
                local response_data = { { id, r.body } }
                ---@diagnostic disable-next-line: param-type-mismatch
                client:notify('tsserver/response', response_data)
              end)
            end
          end,
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

      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

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
          map('gR', builtin.lsp_references, '[G]oto [R]eferences')
          -- Jump to the implementation of the word under your cursor.
          map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
          -- Jump to the type of the word under your cursor.
          map('gT', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
          -- Fuzzy find all the symbols in your current document.
          map('gsd', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          -- Fuzzy find all the symbols in your current workspace.
          map('gsw', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
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

          if client:supports_method 'textDocument/documentHighlight' then
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

          if client:supports_method 'textDocument/documentSymbol' then
            require('nvim-navic').attach(client, event.buf)
          end

          if client:supports_method 'textDocument/inlayHint' then
            map('<leader>ch', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay [H]ints')
          end

          if client:supports_method 'textDocument/codeLens' then
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
