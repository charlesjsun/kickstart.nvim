return {

    'trunk-io/neovim-trunk',
    lazy = false,
    main = 'trunk',
    dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
    -- optionally pin the version
    -- tag = "v0.1.1",
    -- these are optional config arguments (defaults shown)
    config = {
        -- trunkPath = "/home/csun/av/tools/trunk",
        -- lspArgs = {"--help"},
        formatOnSave = false,
        -- formatOnSaveTimeout = 10, -- seconds
        -- logLevel = "info"
    },
}
