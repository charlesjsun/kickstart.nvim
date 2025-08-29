-- Clear highlights on search
-- NOTE: double tap <cr> is needed when mini.clues is enabled
vim.keymap.set('n', '<leader><cr>', '<cmd>nohl<CR>', { desc = 'Clear search highlights' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move selcted lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'L', '>gv')
vim.keymap.set('v', 'H', '<gv')

-- Search and replace current word
vim.keymap.set('n', 'S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search and replace current word' })
-- Search and replace highlighted text
vim.keymap.set('x', '<leader>r', function()
    local selection = require('utils').get_curr_visual_selection()
    if selection == nil then
        return
    end
    -- selection = vim.fn.escape(selection, '^$.*?/\\[]~')
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    -- run find and replace command
    -- local cmd = vim.api.nvim_replace_termcodes('<Cmd>', true, false, true)
    local left = vim.api.nvim_replace_termcodes('<Left>', true, false, true)
    vim.api.nvim_feedkeys(':%s/' .. selection .. '/' .. selection .. '/gI' .. left .. left .. left, 'n', false)
end, { desc = 'Find and [R]eplace curr selection' })

-- Apparently bad so we remove it
vim.keymap.set('n', 'Q', '<nop>')

-- C-c does weird stuff sometimes
vim.keymap.set('i', '<C-c>', '<Esc>')

-- https://github.com/DeadKper/nvim/blob/933f398107f5e4aba8f4d1cd4ed602f6fb278ce1/lua/config/keymaps.lua
local scroll_up = 'normal! ' .. vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
local scroll_dw = 'normal! ' .. vim.api.nvim_replace_termcodes('<C-e>', true, true, true)
local function adjust_view(do_zz, do_zb)
    vim.cmd('normal! m' .. (vim.g.temp_mark or 'p'))
    -- if do_zz == nil or do_zz then
    --     vim.cmd 'normal! zz'
    -- end
    -- if do_zb ~= nil and do_zb then
    --     vim.cmd 'normal! zb'
    -- end

    local prev
    local curr = vim.fn.winline()
    local height = vim.fn.winheight(0)
    local bufend = vim.fn.getpos('$')[2] - vim.fn.getpos('.')[2]

    if (height - curr) - bufend > vim.o.scrolloff then
        while prev ~= curr and (height - curr) - bufend > vim.o.scrolloff do -- scroll one at a time in case of wrapped lines
            vim.cmd(scroll_up)
            prev = curr
            curr = vim.fn.winline()
        end
    elseif height - curr < vim.o.scrolloff then
        while prev ~= curr and height - curr < vim.o.scrolloff do -- scroll one at a time in case of wrapped lines
            vim.cmd(scroll_dw)
            prev = curr
            curr = vim.fn.winline()
        end
    end

    vim.cmd('normal! `' .. (vim.g.temp_mark or 'p'))
    vim.cmd('delm ' .. (vim.g.temp_mark or 'p'))

    -- if vim.g.mini_animate then
    local has_animate, animate = pcall(require, 'mini.animate')
    if has_animate then
        pcall(animate.execute_after, 'scroll', '')
    end
    -- end
end
-- Set zz to center view, but don't show buf end lines and don't center on long wrapped lines
-- vim.keymap.set('n', 'zz', adjust_view, { silent = true })
-- vim.keymap.set('n', 'zb', function()
--     adjust_view(false, true)
-- end, { silent = true })

local function jump(keycomb, do_zz, do_zb)
    local cmd = 'normal! ' .. vim.api.nvim_replace_termcodes(keycomb, true, true, true)
    return function()
        -- local curr = vim.fn.getpos('.')[2]
        vim.cmd(cmd .. 'zz')
        -- if curr == vim.fn.getpos('.')[2] then
        --     vim.cmd(cmd)
        -- end

        -- local has_animate, animate = pcall(require, 'mini.animate')
        -- if has_animate then
        --     pcall(animate.execute_after, 'scroll', adjust_view)
        -- end
        -- adjust_view(do_zz, do_zb)
    end
end
-- Jump half page and center view
vim.keymap.set('n', '<C-u>', jump '<C-u>', { silent = true })
vim.keymap.set('n', '<C-d>', jump '<C-d>', { silent = true })

-- Dealing with wrapped lines
-- vim.keymap.set({ 'n', 'v' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', function()
    if vim.v.count == 0 then
        vim.cmd 'normal! gk'
    else
        vim.cmd('normal! ' .. vim.v.count .. 'k')
    end
    -- adjust_view(false)
end, { silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', function()
    if vim.v.count == 0 then
        vim.cmd 'normal! gj'
    else
        vim.cmd('normal! ' .. vim.v.count .. 'j')
    end
    -- local bufend = vim.fn.getpos('$')[2] - vim.fn.getpos('.')[2]
    -- adjust_view(false, false)
end, { silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
local function custom_n(expr)
    return function()
        if pcall(vim.api.nvim_exec2, 'normal! ' .. vim.fn.eval(expr), { output = false }) then
            vim.cmd 'normal! zz'
        end
    end
end

vim.keymap.set('n', 'n', custom_n "'Nn'[v:searchforward].'zv'", { desc = 'Next Search Result' })
vim.keymap.set('x', 'n', custom_n "'Nn'[v:searchforward]", { desc = 'Next Search Result' })
vim.keymap.set('o', 'n', custom_n "'Nn'[v:searchforward]", { desc = 'Next Search Result' })
vim.keymap.set('n', 'N', custom_n "'nN'[v:searchforward].'zv'", { desc = 'Prev Search Result' })
vim.keymap.set('x', 'N', custom_n "'nN'[v:searchforward]", { desc = 'Prev Search Result' })
vim.keymap.set('o', 'N', custom_n "'nN'[v:searchforward]", { desc = 'Prev Search Result' })
