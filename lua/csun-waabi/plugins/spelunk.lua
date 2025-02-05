return {
    'EvWilson/spelunk.nvim',
    enabled = false,
    dependencies = {
        'nvim-lua/plenary.nvim', -- For window drawing utilities
        'nvim-telescope/telescope.nvim', -- Optional: for fuzzy search capabilities
        'nvim-treesitter/nvim-treesitter', -- Optional: for showing grammar context
    },
    config = function()
        require('spelunk').setup {
            enable_persist = true,
        }
    end,
}
