return {

    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function()
        -- vim.keymap.set('n', 'gs', '<Plug>(leap-from-window)', { desc = 'Leap from Windows' })
        -- vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', '<Plug>(leap-forward)', { desc = '[L]eap Forward to' })
        -- vim.keymap.set({ 'n', 'x', 'o' }, '<leader>L', '<Plug>(leap-backward)', { desc = '[L]eap Backward to' })

        vim.keymap.set('n', 's', '<Plug>(leap)')
        -- vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
        vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
        vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')

        vim.keymap.set({ 'n', 'o' }, 'gs', function()
            require('leap.remote').action()
        end, { desc = '[G]oto [S]neak for remote operation and return' })
    end,
}
