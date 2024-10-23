return {

    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
        -- vim.keymap.set('n', 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from Windows' })
        vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', '<Plug>(leap-forward)', { desc = '[L]eap Forward to' })
        vim.keymap.set({ 'n', 'x', 'o' }, '<leader>L', '<Plug>(leap-backward)', { desc = '[L]eap Backward to' })

        -- vim.keymap.set('n', 's', '<Plug>(leap)')
        -- vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
        -- vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
        -- vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')

        vim.keymap.set({ 'n', 'o' }, 'gl', function()
            require('leap.remote').action()
        end, { desc = '[G]oto [L]eap for remote operation and return' })
    end,
    -- keys = {
    --     { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap Forward to' },
    --     { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap Backward to' },
    --     { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from Windows' },
    -- },
    -- config = function(_, opts)
    --     local leap = require 'leap'
    --     for k, v in pairs(opts) do
    --         leap.opts[k] = v
    --     end
    --     leap.add_default_mappings(true)
    --     vim.keymap.del({ 'x', 'o' }, 'x')
    --     vim.keymap.del({ 'x', 'o' }, 'X')
    -- end,
}
