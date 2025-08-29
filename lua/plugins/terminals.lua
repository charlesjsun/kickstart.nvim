return {

    {
        'ii14/neorepl.nvim',
        config = function()
            vim.keymap.set('n', '<leader>tlh', function()
                -- get current buffer and window
                local buf = vim.api.nvim_get_current_buf()
                local win = vim.api.nvim_get_current_win()
                -- create a new split for the repl
                vim.cmd 'split'
                -- spawn repl and set the context to our buffer
                require('neorepl').new {
                    lang = 'lua',
                    buffer = buf,
                    window = win,
                }
            end, { desc = 'Open [T]erminal [L]ua in [H]orizontal split' })

            vim.keymap.set('n', '<leader>tlv', function()
                -- get current buffer and window
                local buf = vim.api.nvim_get_current_buf()
                local win = vim.api.nvim_get_current_win()
                -- create a new split for the repl
                vim.cmd 'vsplit'
                -- spawn repl and set the context to our buffer
                require('neorepl').new {
                    lang = 'lua',
                    buffer = buf,
                    window = win,
                }
            end, { desc = 'Open [T]erminal [L]ua in [V]ertical split' })
        end,
    },

    {
        'Vigemus/iron.nvim',
        event = 'VeryLazy',
        config = function()
            local iron = require 'iron.core'
            iron.setup {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here
                    repl_definition = {
                        sh = {
                            -- Can be a table or a function that
                            -- returns a table (see below)
                            command = { 'bash' },
                        },
                        python = {
                            -- command = { '/home/csun/av/tools/IPython' }, -- or { "ipython", "--no-autoindent" }
                            command = { 'python3' },
                            format = require('iron.fts.common').bracketed_paste_python,
                        },
                    },
                    -- How the repl window will be displayed
                    -- See below for more information
                    repl_open_cmd = require('iron.view').split.vertical '50%',
                },
                -- Iron doesn't set keymaps by default anymore.
                -- You can set them here or manually add keymaps to the functions in iron.core
                keymaps = {
                    send_motion = '<leader>tsc',
                    visual_send = '<leader>ts',
                    send_file = '<leader>tsf',
                    send_line = '<leader>tsl',
                    send_paragraph = '<leader>tsp',
                    send_until_cursor = '<leader>tsu',
                    send_mark = '<leader>tsm',
                    mark_motion = '<leader>tmc',
                    mark_visual = '<leader>tm',
                    remove_mark = '<leader>tmd',
                    cr = '<leader>ts<cr>',
                    interrupt = '<leader>t<space>',
                    exit = '<leader>tq',
                    clear = '<leader>tc',
                },
                -- If the highlight is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            }
        end,
    },
}
