return {

    { -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then
        -- change the command in the config to whatever the name of that colorscheme is.
        --
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
        'folke/tokyonight.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        -- enabled = true,
        init = function()
            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme 'tokyonight-moon'

            -- You can configure highlights by doing something like:
            -- vim.cmd.hi 'Comment gui=none'
        end,
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        -- priority = 1000,
        init = function()
            -- vim.cmd.colorscheme 'catppuccin-mocha'
        end,
        opts = {
            flavour = 'mocha', -- latte, frappe, macchiato, mocha, auto
        },
    },

    { 'EdenEast/nightfox.nvim' },

    { 'shaunsingh/nord.nvim' },

    { 'marko-cerovac/material.nvim' },

    {
        'navarasu/onedark.nvim',
        opts = {
            style = 'warmer',
        },
    },

    { 'rebelot/kanagawa.nvim' },

    -- {
    --     'echasnovski/mini.base16',
    --     priority = 1000,
    --     version = false,
    --     event = 'VimEnter',
    --     enabled = true,
    --     config = function()
    --         vim.cmd("colorscheme catppuccin-macchiato")
    --     end,
    -- }
}
