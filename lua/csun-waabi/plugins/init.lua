return {

    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- Highlight todo, notes, etc in comments
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },

    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {
            -- The pattern used for the internal autocmd to determine
            -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
            pattern = '*',
            -- Whether or not scrollEOF should be enabled in insert mode
            insert_mode = true,
            -- Whether or not scrollEOF should be enabled in floating windows
            floating = false,
            -- List of filetypes to disable scrollEOF for.
            disabled_filetypes = {},
            -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
            disabled_modes = {},
        },
    },

    -- Peek lines when doing :number commands
    {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end,
    },

    -- {
    --     'tzachar/local-highlight.nvim',
    --     config = function()
    --         require('local-highlight').setup()
    --     end,
    -- },
}
