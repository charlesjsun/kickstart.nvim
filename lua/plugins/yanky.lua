return {
    'gbprod/yanky.nvim',
    -- dependencies = {
    --     {
    --         'nvim-telescope/telescope.nvim',
    --         dependencies = { 'nvim-lua/plenary.nvim' },
    --     },
    -- },
    config = function()
        local utils = require 'yanky.utils'
        -- local mapping = require 'yanky.telescope.mapping'

        require('yanky').setup {
            ring = {
                history_length = 100,
                storage = 'shada',
                sync_with_numbered_registers = true,
                cancel_event = 'update',
                ignore_registers = { '_' },
                update_register_on_cycle = false,
            },
            picker = {
                select = {
                    action = nil, -- nil to use default put action
                },
                -- telescope = {
                --     use_default_mappings = false, -- if default mappings should be used
                --     mappings = {
                --         default = mapping.put 'p',
                --         i = {
                --             ['<c-x>'] = mapping.delete(),
                --             ['<c-r>'] = mapping.set_register(utils.get_default_register()),
                --         },
                --         n = {
                --             p = mapping.put 'p',
                --             P = mapping.put 'P',
                --             d = mapping.delete(),
                --             r = mapping.set_register(utils.get_default_register()),
                --         },
                --     },
                -- },
            },
            system_clipboard = {
                sync_with_ring = false,
                clipboard_register = nil,
            },
            highlight = {
                on_put = true,
                on_yank = true,
                timer = 500,
            },
            preserve_cursor_position = {
                enabled = true,
            },
            textobj = {
                enabled = true,
            },
        }

        vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
        vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
        vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
        vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')

        vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')

        -- local yanky = require 'yanky'
        -- vim.keymap.set('i', '<c-r>p', function()
        --     yanky.put('p', false)
        -- end)
        -- vim.keymap.set('i', '<c-r>k', function()
        --     yanky.cycle(-1)
        -- end)
        -- vim.keymap.set('i', '<c-r>j', function()
        --     yanky.cycle(1)
        -- end)

        vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
        vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

        -- local telescope = require 'telescope'
        -- telescope.load_extension 'yank_history'
        -- vim.keymap.set('n', '<leader>sy', function()
        --     telescope.extensions.yank_history.yank_history { previewer = false }
        --     -- require('yanky.telescope.yank_history').yank_history {
        --     --     previewer = false,
        --     -- }
        -- end, { desc = '[S]earch [Y]anky history' })
    end,
}
