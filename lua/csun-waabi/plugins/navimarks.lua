return {
    'zongben/navimark.nvim',
    enabled = false,
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require('navimark').setup {
            keymap = {
                base = {
                    mark_toggle = '<leader>mm',
                    mark_add = '<leader>ma',
                    mark_remove = '<leader>mr',
                    goto_next_mark = ']m',
                    goto_prev_mark = '[m',
                    open_mark_picker = '<leader>fm',
                },
                telescope = {
                    i = {
                        delete_mark = '<C-x>',
                    },
                    n = {
                        delete_mark = 'd',
                        clear_marks = 'c',
                        new_stack = 'n',
                        next_stack = '<Tab>',
                        prev_stack = '<S-Tab>',
                        rename_stack = 'r',
                        delete_stack = 'D',
                        open_all_marked_files = '<C-o>', -- open all marked files in current stack
                    },
                },
            },
            sign = {
                text = '',
                color = '#FF0000',
            },
            --set to true to persist marks
            persist = true,
        }
    end,
}
