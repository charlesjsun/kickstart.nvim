return {
    -- Add indent guides on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    config = function()
        require('ibl').setup {
            indent = {
                char = '▏',
                repeat_linebreak = true,
            },
            viewport_buffer = {
                min = 100,
            },
            scope = { enabled = false },
        }
    end,
}
