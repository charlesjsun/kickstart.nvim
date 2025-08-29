return {
    -- LSP Plugins

    -- {
    --     -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    --     -- used for completion, annotations and signatures of Neovim apis
    --     'folke/lazydev.nvim',
    --     enabled = true,
    --     ft = 'lua',
    --     opts = {
    --         library = {
    --             -- Load luvit types when the `vim.uv` word is found
    --             { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    --             -- { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    --         },
    --     },
    -- },

    {
        'Bilal2453/luvit-meta',
        enabled = true,
        -- lazy = true,
    },

    -- status bar to show breadcrubs
    -- {
    --     'SmiteshP/nvim-navic',
    --     dependencies = { 'neovim/nvim-lspconfig' },
    --     opts = {},
    -- },
    --

    {
        -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        enabled = true,
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
            -- 'williamboman/mason-lspconfig.nvim',
            -- 'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Allows extra capabilities provided by nvim-cmp
            'hrsh7th/cmp-nvim-lsp',

            -- rust
            {
                'mrcjkb/rustaceanvim',
                version = '^5', -- Recommended
                lazy = false, -- This plugin is already lazy
            },
        },
        config = function()
            -- vim.api.nvim_create_autocmd('LspProgress', {
            --     group = vim.api.nvim_create_augroup('lsp_progress_print', { clear = true }),
            --     callback = function(ev)
            --         local value = ev.data.params.value
            --         if value.kind == 'begin' then
            --             print(vim.inspect(value))
            --         elseif value.kind == 'end' then
            --             print(vim.inspect(value))
            --         elseif value.kind == 'report' then
            --             print(vim.inspect(value))
            --         end
            --     end,
            -- })
            --
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_attach_set_keybinds', { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local filetype = vim.fn.getbufvar(event.buf, '&filetype')

                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        local prefix = 'LSP: '
                        if filetype == 'rust' then
                            prefix = 'Rust: '
                        end

                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = prefix .. desc })
                    end

                    local mini_extra_picker = function(func)
                        local callable = function()
                            local on_list = function(opts)
                                if table.getn(opts.items) > 1 then
                                    require('mini.extra').pickers.lsp { scope = func }
                                else
                                    vim.lsp.buf[func]()
                                end
                            end
                            vim.lsp.buf[func] { on_list = on_list }
                        end
                        return callable
                    end

                    -- Remove new nvim 0.11.0 default lsp mappings
                    -- vim.keymap.del('n', 'gra', { buffer = event.buf })
                    -- vim.keymap.del('n', 'gri', { buffer = event.buf })
                    -- vim.keymap.del('n', 'grn', { buffer = event.buf })
                    -- vim.keymap.del('n', 'grr', { buffer = event.buf })

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gd', mini_extra_picker 'definition', '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    -- map('grr', require('telescope.builtin').lsp_references, 'Goto [R]eferences')
                    map('grr', mini_extra_picker 'references', '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    -- map('gri', require('telescope.builtin').lsp_implementations, 'Goto [I]mplementation')
                    map('gri', mini_extra_picker 'implementation', 'Goto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('grt', mini_extra_picker 'type_definition', '[G]oto [T]ype Definition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ds', function()
                        require('mini.extra').pickers.lsp { scope = 'document_symbol' }
                    end, '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>ws', function()
                        require('mini.extra').pickers.lsp { scope = 'workspace_symbol' }
                    end, '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('grn', vim.lsp.buf.rename, 'Re[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    if filetype == 'rust' then
                        map('gra', function()
                            vim.cmd.RustLsp 'codeAction'
                        end, 'Code [A]ction', { 'n', 'x' })
                    else
                        map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
                    end

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                    -- Hover action
                    if filetype == 'rust' then
                        map('K', function()
                            vim.cmd.RustLsp { 'hover', 'actions' }
                        end, 'Hover', 'n')
                    else
                        map('K', vim.lsp.buf.hover, 'Hover', 'n')
                    end

                    if filetype == 'rust' then
                        map('<leader>me', function()
                            vim.cmd.RustLsp 'expandMacro'
                        end, '[M]acro [E]xpand', 'n')
                    end

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup('lsp_attach_lsp_highlight', { clear = false })
                        vim.api.nvim_create_autocmd({ 'CursorHold' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd('LspDetach', {
                            group = vim.api.nvim_create_augroup('lsp_attach_lsp_detach_clear_highlight', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'lsp_attach_lsp_highlight', buffer = event2.buf }
                            end,
                        })
                    end

                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    --
                    -- This may be unwanted, since they displace some of your code
                    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')

                        vim.lsp.inlay_hint.enable(true)
                    end

                    -- autocomplete
                    -- default autocomplete sucks
                    -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
                    --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
                    -- end
                end,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client == nil then
                        return
                    end
                    if client.name == 'ruff' then
                        -- Disable hover in favor of Pyrefly
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                desc = 'LSP: Disable hover capability from Ruff',
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            --
            require('mason').setup()

            vim.lsp.config['lua_ls'] = {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                root_markers = {
                    '.luarc.json',
                    '.luarc.jsonc',
                    '.luacheckrc',
                    '.stylua.toml',
                    'stylua.toml',
                    'selene.toml',
                    'selene.yml',
                    '.git',
                },
                -- single_file_support = true,
                -- telemetry = { enabled = false },
                -- formatters = {
                --     ignoreComments = false,
                -- },
                settings = {
                    Lua = {
                        -- runtime = {
                        --     version = 'LuaJIT',
                        --     path = {
                        --         '?.lua',
                        --         '?/init.lua',
                        --     },
                        -- },
                        -- signatureHelp = { enabled = true },
                        -- completion = {
                        --     callSnippet = 'Replace',
                        -- },
                    },
                },
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most
                            -- likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                            -- Tell the language server how to find Lua modules same way as Neovim
                            -- (see `:h lua-module-load`)
                            path = {
                                'lua/?.lua',
                                'lua/?/init.lua',
                            },
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths
                                -- here.
                                '${3rd}/luv/library',
                                -- '${3rd}/busted/library'
                            },
                            -- Or pull in all of 'runtimepath'.
                            -- NOTE: this is a lot slower and will cause issues when working on
                            -- your own configuration.
                            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                            -- library = {
                            --   vim.api.nvim_get_runtime_file('', true),
                            -- }
                        },
                    })
                end,
            }
            vim.lsp.enable 'lua_ls'

            -- vim.lsp.config['basedpyright'] = {
            --     cmd = { 'basedpyright-langserver', '--stdio' },
            --     filetypes = { 'python' },
            --     root_markers = {
            --         'pyproject.toml',
            --         'setup.py',
            --         'setup.cfg',
            --         'requirements.txt',
            --         'Pipfile',
            --         'pyrightconfig.json',
            --         '.git',
            --     },
            --     settings = {
            --         basedpyright = {
            --             analysis = {
            --                 autoSearchPaths = true,
            --                 useLibraryCodeForTypes = true,
            --                 diagnosticMode = 'openFilesOnly',
            --             },
            --         },
            --     },
            -- }
            -- vim.lsp.enable 'basedpyright'

            vim.lsp.config['pyrefly'] = {
                cmd = { 'pyrefly', 'lsp' },
                filetypes = { 'python' },
                rootPatterns = {
                    'pyrefly.toml',
                    'pyproject.toml',
                    '.git',
                },
            }
            vim.lsp.enable 'pyrefly'

            vim.lsp.config['ruff'] = {
                cmd = { 'ruff', 'server' },
                filetypes = { 'python' },
                init_options = {
                    settings = {
                        configuration = '.ruff.toml',
                    },
                },
            }
            vim.lsp.enable 'ruff'

            -- vim.lsp.config['bzl'] = {
            --     cmd = { 'bzl', 'lsp', 'serve' },
            --     filetypes = { 'bzl' },
            --     root_dir = 'WORKSPACE',
            -- }
            -- vim.lsp.enable 'bzl'

            -- vim.lsp.config['starlark-rust'] = {
            --     cmd = { 'starlark', '--lsp' },
            --     filetypes = { 'bzl' },
            --     root_markers = { 'WORKSPACE' },
            --     -- root_dir = function(fname)
            --     --     return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            --     -- end,
            -- }
            -- vim.lsp.enable 'starlark-rust'

            vim.lsp.config['bazel-lsp'] = {
                cmd = { 'bazel-lsp' },
                filetypes = { 'bzl' },
                root_markers = { 'WORKSPACE' },
            }
            vim.lsp.enable 'bazel-lsp'

            -- rustacean configs
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {},
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr) end,
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ['rust-analyzer'] = {
                            rustfmt = {
                                extraArgs = { '--edition=2021' },
                            },
                            check = {
                                overrideCommand = { 'tools/rust_check.sh' },
                                -- extraEnv = {
                                --     RUSTC = '/home/csun/av/tools/rustc',
                                -- },
                            },
                            -- runnables = {
                            --     command = 'tools/cargo',
                            -- },
                            -- rustc = {
                            --     source = '/home/csun/av/Cargo.toml',
                            -- },
                            -- cargo = {
                            --     buildScripts = {
                            --         enable = true,
                            --         overrideCommand = { 'tools/rust_check.sh' },
                            --         --     useRustcWrapper = false,
                            --     },
                            --     -- extraEnv = {
                            --     --     RUSTC = '/home/csun/av/tools/rustc',
                            --     -- },
                            -- },
                            procMacro = {
                                enable = true,
                            },
                            -- diagnostics = {
                            --     disabled = { 'unresolved-macro-call' },
                            -- },
                            semanticHighlighting = {
                                punctuation = {
                                    enable = true,
                                },
                            },
                        },
                    },
                },
                -- DAP configuration
                dap = {},
            }
        end,
    },
}
