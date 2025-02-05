return {
    'fnune/recall.nvim',
    version = '*',
    dependencies = {
        {
            'nvim-telescope/telescope.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
        },
    },
    config = function()
        local recall = require 'recall'

        recall.setup {
            telescope = {
                mappings = {
                    unmark_selected_entry = {
                        normal = 'dd',
                        insert = '<C-x>',
                    },
                },
            },
        }

        vim.keymap.set('n', '<leader>mm', recall.toggle, { noremap = true, silent = true, desc = '[M]ark [M]mark' })
        vim.keymap.set('n', '<leader>mn', recall.goto_next, { noremap = true, silent = true, desc = '[M]ark [N]ext' })
        vim.keymap.set('n', '<leader>mp', recall.goto_prev, { noremap = true, silent = true, desc = '[M]ark [P]revious' })
        vim.keymap.set('n', '<leader>mc', recall.clear, { noremap = true, silent = true, desc = '[M]ark [C]lear' })
        vim.keymap.set('n', '<leader>sm', ':Telescope recall<CR>', { noremap = true, silent = true, desc = '[S]earch [M]arks' })
    end,
}
