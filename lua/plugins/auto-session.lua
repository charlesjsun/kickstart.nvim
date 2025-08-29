return {
    'rmagatti/auto-session',
    lazy = false,
    enabled = false,
    dependencies = {
        { 'nvim-telescope/telescope.nvim' },
    },
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { '<leader>ss', '<cmd>SessionSearch<CR>', desc = '[S]earch [S]essions' },
        -- { '<leader>Ss', '<cmd>SessionSave<CR>', desc = 'Save session' },
        -- { '<leader>Sa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Session toggle autosave' },
    },
    opts = {
        session_lens = {
            -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
            load_on_setup = true,
            previewer = false,
            mappings = {
                -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                delete_session = { 'i', '<C-x>' },
                alternate_session = { 'i', '<C-s>' },
                copy_session = { 'i', '<C-y>' },
            },
            -- Can also set some Telescope picker options
            -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
            theme_conf = {
                border = true,
            },
        },
    },
}
