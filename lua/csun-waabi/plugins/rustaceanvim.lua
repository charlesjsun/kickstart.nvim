return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy

    enabled = false,

    config = function()
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    -- you can also put keymaps in here
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ['rust-analyzer'] = {
                        rustfmt = {
                            overrideCommand = 'trunk fmt',
                        },
                        check = {
                            overrideCommand = 'tools/rust_check.sh',
                            -- extraEnv = {
                            --     RUSTC = '/home/csun/av/tools/rustc',
                            -- },
                        },
                        runnables = {
                            command = 'tools/cargo',
                        },
                        rustc = {
                            source = 'Cargo.toml',
                        },
                        cargo = {
                            -- buildScripts = {
                            --     useRustcWrapper = false,
                            -- },
                            extraEnv = {
                                RUSTC = '/home/csun/av/tools/rustc',
                            },
                        },
                        buildScripts = {
                            enable = true,
                        },
                        procMacro = {
                            enable = true,
                        },
                        -- diagnostics = {
                        --     disabled = { 'unresolved-macro-call' },
                        -- },
                    },
                },
            },
            -- DAP configuration
            dap = {},
        }
    end,
}
