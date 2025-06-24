return {
    -- LSP Plugins

    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        enabled = true,
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },

    {
        'Bilal2453/luvit-meta',
        enabled = true,
        lazy = true,
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
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('my-lsp-attach', { clear = true }),
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

                    -- Remove new nvim 0.11.0 default lsp mappings
                    -- vim.keymap.del('n', 'gra', { buffer = event.buf })
                    -- vim.keymap.del('n', 'gri', { buffer = event.buf })
                    -- vim.keymap.del('n', 'grn', { buffer = event.buf })
                    -- vim.keymap.del('n', 'grr', { buffer = event.buf })

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gd', function()
                        local on_list = function(opts)
                            if table.getn(opts.items) > 1 then
                                require('mini.extra').pickers.lsp { scope = 'definition' }
                            else
                                vim.lsp.buf.definition()
                            end
                        end
                        vim.lsp.buf.definition { on_list = on_list }
                    end, '[G]oto [D]efinition')

                    -- Find references for the word under your cursor.
                    -- map('grr', require('telescope.builtin').lsp_references, 'Goto [R]eferences')
                    map('grr', function()
                        require('mini.extra').pickers.lsp { scope = 'references' }
                    end, '[G]oto [R]eferences')

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    -- map('gri', require('telescope.builtin').lsp_implementations, 'Goto [I]mplementation')
                    map('gri', function()
                        require('mini.extra').pickers.lsp { scope = 'implementation' }
                    end, 'Goto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    -- map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>D', function()
                        require('mini.extra').pickers.lsp { scope = 'type_definition' }
                    end, 'Type [D]efinition')

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
                        local highlight_augroup = vim.api.nvim_create_augroup('my-lsp-highlight', { clear = false })
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
                            group = vim.api.nvim_create_augroup('my-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
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

                        vim.lsp.inlay_hint.enable()
                    end

                    -- autocomplete
                    -- default autocomplete sucks
                    -- if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
                    --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = false })
                    -- end
                end,
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

            vim.lsp.config['luals'] = {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                root_markers = { '.luarc.json', '.luarc.jsonc' },
                telemetry = { enabled = false },
                formatters = {
                    ignoreComments = false,
                },
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        signatureHelp = { enabled = true },
                        -- completion = {
                        --     callSnippet = 'Replace',
                        -- },
                    },
                },
            }
            vim.lsp.enable 'luals'

            vim.lsp.config['basedpyright'] = {
                cmd = { 'basedpyright-langserver', '--stdio' },
                filetypes = { 'python' },
                root_markers = {
                    'pyproject.toml',
                    'setup.py',
                    'setup.cfg',
                    'requirements.txt',
                    'Pipfile',
                    'pyrightconfig.json',
                    '.git',
                },
                settings = {
                    basedpyright = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = 'openFilesOnly',
                        },
                    },
                },
            }
            vim.lsp.enable 'basedpyright'

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
