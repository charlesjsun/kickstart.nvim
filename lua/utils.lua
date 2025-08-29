local M = {}

function M.get_curr_visual_selection()
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' then
        vim.notify('This action can only be done in visual mode.', vim.log.levels.INFO)
        return nil
    end

    local _, csrow, cscol, _ = unpack(vim.fn.getpos '.')
    local _, cerow, cecol, _ = unpack(vim.fn.getpos 'v')
    if mode == 'V' then
        -- visual line doesn't provide columns
        cscol, cecol = 0, 999
    end

    if cerow < csrow then
        csrow, cerow = cerow, csrow
    end
    if cecol < cscol then
        cscol, cecol = cecol, cscol
    end

    local lines = vim.fn.getline(csrow, cerow)
    -- local n = cerow-csrow+1
    local n = table.getn(lines)
    if n <= 0 then
        return ''
    end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)

    local text = vim.trim(table.concat(lines, '\n'))

    return text
end

return M
