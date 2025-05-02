return {
    'MisanthropicBit/winmove.nvim',
    config = function()
        local winmove = require 'winmove'
        require('winmove').configure {
            keymaps = {
                help = '?', -- Open floating window with help for the current mode
                help_close = 'q', -- Close the floating help window
                quit = 'q', -- Quit current mode
                toggle_mode = '<tab>', -- Toggle between modes when in a mode
            },
            modes = {
                move = {
                    highlight = 'Visual', -- Highlight group for move mode
                    at_edge = {
                        horizontal = winmove.AtEdge.None, -- Behaviour at horizontal edges
                        vertical = winmove.AtEdge.None, -- Behaviour at vertical edges
                    },
                    keymaps = {
                        left = 'h', -- Move window left
                        down = 'j', -- Move window down
                        up = 'k', -- Move window up
                        right = 'l', -- Move window right
                        far_left = 'H', -- Move window far left and maximize it
                        far_down = 'J', -- Move window down and maximize it
                        far_up = 'K', -- Move window up and maximize it
                        far_right = 'L', -- Move window right and maximize it
                        split_left = 'sh', -- Create a split with the window on the left
                        split_down = 'sj', -- Create a split with the window below
                        split_up = 'sk', -- Create a split with the window above
                        split_right = 'sl', -- Create a split with the window on the right
                    },
                },
                swap = {
                    highlight = 'Substitute', -- Highlight group for swap mode
                    at_edge = {
                        horizontal = winmove.AtEdge.None, -- Behaviour at horizontal edges
                        vertical = winmove.AtEdge.None, -- Behaviour at vertical edges
                    },
                    keymaps = {
                        left = 'h', -- Swap left
                        down = 'j', -- Swap down
                        up = 'k', -- Swap up
                        right = 'l', -- Swap right
                    },
                },
                resize = {
                    highlight = 'Todo', -- Highlight group for resize mode
                    default_resize_count = 3, -- Default amount to resize windows
                    keymaps = {
                        -- When resizing, the anchor is in the top-left corner of the window by default
                        left = 'h', -- Resize to the left
                        down = 'j', -- Resize down
                        up = 'k', -- Resize up
                        right = 'l', -- Resize to the right
                        left_botright = '<c-h>', -- Resize left with bottom-right anchor
                        down_botright = '<c-j>', -- Resize down with bottom-right anchor
                        up_botright = '<c-k>', -- Resize up with bottom-right anchor
                        right_botright = '<c-l>', -- Resize right with bottom-right anchor
                    },
                },
            },
        }

        vim.keymap.set('n', '<C-w>m', function()
            winmove.start_mode(winmove.Mode.Move)
        end, { desc = '[M]ove Mode' })
        vim.keymap.set('n', '<C-w>r', function()
            winmove.start_mode(winmove.Mode.Resize)
        end, { desc = '[R]esize Mode' })
    end,
}
