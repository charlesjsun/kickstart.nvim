return {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    version = false,
    lazy = false,
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
        -- More icons!
        require('mini.icons').setup()

        -- Highlight cursor word
        -- require('mini.cursorword').setup {
        --     delay = 100,
        -- }

        -- Autopairs
        -- require('mini.pairs').setup {
        --     modes = { insert = true, command = false, terminal = false },
        --     mappings = {
        --         ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][^a-zA-Z0-9([{\'"]' },
        --         ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][^a-zA-Z0-9([{\'"]' },
        --         ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][^a-zA-Z0-9([{\'"]' },
        --
        --         [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        --         [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        --         ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
        --
        --         ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
        --         ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
        --         ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        --     },
        -- }

        -- Split and join args with gS
        require('mini.splitjoin').setup()

        -- Animate
        -- Disable animation when using mouse to scroll
        -- local mouse_scrolled = false
        -- for _, scroll in ipairs { 'Up', 'Down' } do
        --     local key = '<ScrollWheel' .. scroll .. '>'
        --     vim.keymap.set({ '', 'i' }, key, function()
        --         mouse_scrolled = true
        --         return key
        --     end, { expr = true })
        -- end
        -- local max_time = 80
        -- local scroll_time = 10
        -- local steps = math.floor(max_time / scroll_time)
        -- if steps > 60 then
        --     steps = 60
        -- end

        -- vim.g.mini_animate = true
        -- local mini_animate = require 'mini.animate'
        -- mini_animate.setup {
        --     cursor = {
        --         enable = false,
        --     },
        --     scroll = {
        --         -- timing = mini_animate.gen_timing.linear({ duration = 50, unit = 'total' }),
        --         timing = mini_animate.gen_timing.linear { duration = scroll_time, unit = 'step', easing = 'in' },
        --         subscroll = mini_animate.gen_subscroll.equal {
        --             predicate = function(total_scroll)
        --                 if mouse_scrolled then
        --                     mouse_scrolled = false
        --                     return false
        --                 end
        --                 return total_scroll > 1
        --             end,
        --             max_output_steps = steps,
        --         },
        --     },
        --     open = { enable = false },
        --     close = { enable = false },
        -- }

        -- local animate_after = function(input, command)
        --     local pre_command = function()
        --         vim.cmd("normal! " .. input)
        --     end
        --     if string.sub(input, 1, 2) == "<C" then
        --         pre_command = function()
        --             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(input, true, false, true), "n", true)
        --         end
        --     end
        --     return function()
        --         pre_command()
        --         mini_animate.execute_after("scroll", "normal! " .. command)
        --     end
        -- end
        -- vim.keymap.set("n", "n", animate_after("n", "zvzz"))
        -- vim.keymap.set("n", "N", animate_after("N", "zvzz"))
        -- vim.keymap.set("n", "<C-d>", animate_after("<C-d>", "zvzz"))
        -- vim.keymap.set("n", "<C-u>", animate_after("<C-u>", "zvzz"))

        local mini_indentscope = require 'mini.indentscope'
        mini_indentscope.setup {
            symbol = '▏',
            options = { try_as_border = true },
            draw = {
                delay = 100,
                animation = mini_indentscope.gen_animation.none(),
                priority = 2,
            },
        }

        -- Extra options for for mini.ai and mini.pick
        local mini_extra = require 'mini.extra'
        mini_extra.setup()

        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        local mini_ai = require 'mini.ai'
        local extra_ai_spec = mini_extra.gen_ai_spec
        local treesitter_ai_spec = mini_ai.gen_spec.treesitter
        require('mini.ai').setup {
            n_lines = 1000,
            custom_textobjects = {
                B = extra_ai_spec.buffer(),
                L = extra_ai_spec.line(),
                N = extra_ai_spec.number(),
                F = treesitter_ai_spec { a = '@function.outer', i = '@function.inner' },
                C = treesitter_ai_spec { a = '@class.outer', i = '@class.inner' },
                S = treesitter_ai_spec { a = '@block.outer', i = '@block.inner' },
            },
        }

        -- Use [ and ] to navigate around
        require('mini.bracketed').setup {
            -- Disable creation of mappings for `indent` target in favor of ones from |mini.indentscope|
            -- indent = { suffix = '' },
        }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup {
            -- Add custom surroundings to be used on top of builtin ones. For more
            -- information with examples, see `:h MiniSurround.config`.
            custom_surroundings = nil,

            -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
            highlight_duration = 500,

            -- Module mappings. Use `''` (empty string) to disable one.
            mappings = {
                add = '<leader>Sa', -- Add surrounding in Normal and Visual modes
                delete = '<leader>Sd', -- Delete surrounding
                find = '<leader>Sf', -- Find surrounding (to the right)
                find_left = '<leader>SF', -- Find surrounding (to the left)
                highlight = '<leader>Sh', -- Highlight surrounding
                replace = '<leader>Sr', -- Replace surrounding
                update_n_lines = '<leader>Sn', -- Update `n_lines`

                suffix_last = 'l', -- Suffix to search with "prev" method
                suffix_next = 'n', -- Suffix to search with "next" method
            },

            -- Number of lines within which surrounding is searched
            n_lines = 20,

            -- Whether to respect selection type:
            -- - Place surroundings on separate lines in linewise mode.
            -- - Place surroundings on each line in blockwise mode.
            respect_selection_type = false,

            -- How to search for surrounding (first inside current line, then inside
            -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
            -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
            -- see `:h MiniSurround.config`.
            search_method = 'cover',

            -- Whether to disable showing non-error feedback
            silent = false,
        }
        -- Disable default keybind for s (if we don't use it for leap
        -- vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

        -- Improved f/t jumps to allow for multiple lines
        require('mini.jump').setup {
            delay = {
                -- Delay between jump and highlighting all possible jumps
                highlight = 10000000,
                -- Delay between jump and automatic stop if idle (no jump is done)
                idle_stop = 0,
            },
        }

        local mini_files = require 'mini.files'
        mini_files.setup {
            mappings = {
                close = 'q',
                go_in = 'l',
                go_in_plus = 'L',
                go_out = 'h',
                go_out_plus = 'H',
                mark_goto = "'",
                mark_set = 'm',
                reset = ',',
                reveal_cwd = '.',
                show_help = 'g?',
                synchronize = '=',
                trim_left = '<',
                trim_right = '>',
            },
            options = {
                -- Whether to delete permanently or move into module-specific trash
                permanent_delete = false,
                -- Whether to use for editing directories
                use_as_default_explorer = true,
            },
            windows = {
                preview = true,
            },
        }
        vim.keymap.set('n', '<leader>e', function()
            mini_files.open(vim.api.nvim_buf_get_name(0), true)
        end, { desc = 'Open files [E]xplorer' })

        vim.keymap.set('n', '<leader>E', function()
            mini_files.open()
        end, { desc = 'Open files [E]xplorer (CWD)' })

        -- Opens a panel to show which keys can be used next in a keymap
        -- NOTE: This plugin changes the behavior of <CR> and <BS> in a keymap.
        -- <BS> will delete pressed keys in the keymap.
        -- <CR> will confirm the keymap with the current state.
        --      e.g. if you have two keymaps <leader>s, <leader>sg, pressing <leader>s<CR> will execute <leader>s.
        --      This means that using <CR> and <BS> in your keymaps requires double tapping the keys.
        local mini_clue = require 'mini.clue'
        mini_clue.setup {
            triggers = {
                -- Leader triggers
                { mode = 'n', keys = '<Leader>' },
                { mode = 'x', keys = '<Leader>' },

                -- Built-in completion
                { mode = 'i', keys = '<C-x>' },

                -- `g` key
                { mode = 'n', keys = 'g' },
                { mode = 'x', keys = 'g' },

                -- Marks
                { mode = 'n', keys = "'" },
                { mode = 'n', keys = '`' },
                { mode = 'x', keys = "'" },
                { mode = 'x', keys = '`' },

                -- Registers
                { mode = 'n', keys = '"' },
                { mode = 'x', keys = '"' },
                { mode = 'i', keys = '<C-r>' },
                { mode = 'c', keys = '<C-r>' },

                -- Window commands
                { mode = 'n', keys = '<C-w>' },

                -- `z` key
                { mode = 'n', keys = 'z' },
                { mode = 'x', keys = 'z' },

                -- `[` and `]` keys
                { mode = 'n', keys = '[' },
                { mode = 'n', keys = ']' },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                mini_clue.gen_clues.builtin_completion(),
                mini_clue.gen_clues.g(),
                mini_clue.gen_clues.marks(),
                mini_clue.gen_clues.registers(),
                mini_clue.gen_clues.windows(),
                mini_clue.gen_clues.z(),

                { mode = 'n', keys = '<leader>s', desc = '+[S]earch Telescope' },
                { mode = 'x', keys = '<leader>s', desc = '+[S]earch Telescope' },
                { mode = 'n', keys = '<leader>t', desc = '+[T]oggle/[T]erminal' },
                { mode = 'n', keys = '<leader>tl', desc = '+[T]erminal [L]ua' },
                { mode = 'n', keys = '<leader>S', desc = '+[S]urround' },
                { mode = 'x', keys = '<leader>S', desc = '+[S]urround' },
                { mode = 'n', keys = '<leader>v', desc = '+[V]isits' },
            },

            window = {
                -- Floating window config
                config = {
                    width = 'auto',
                    row = 'auto',
                    col = 'auto',
                },

                -- Delay before showing clue window
                delay = 500,

                -- Keys to scroll inside the clue window
                scroll_down = '<C-d>',
                scroll_up = '<C-u>',
            },
        }

        -- Visits
        local mini_visits = require 'mini.visits'
        mini_visits.setup()

        vim.keymap.set('n', '<leader>va', mini_visits.add_label, { desc = '[V]isits [A]dd label' })
        vim.keymap.set('n', '<leader>vd', mini_visits.remove_label, { desc = '[V]isits [D]elete label' })

        ------------------------------------------
        ------------------------------------------
        -- Fuzzy finder
        ------------------------------------------
        ------------------------------------------
        local mini_pick_enabled = true
        if mini_pick_enabled then
            vim.env.RIPGREP_CONFIG_PATH = '/home/csun/.ripgreprc'

            local mini_pick = require 'mini.pick'

            local win_config = function()
                local height = math.floor(0.75 * vim.o.lines)
                local width = math.floor(0.75 * vim.o.columns)
                return {
                    anchor = 'NW',
                    height = height,
                    width = width,
                    row = math.floor(0.5 * (vim.o.lines - height)),
                    col = math.floor(0.5 * (vim.o.columns - width)),
                    border = 'double',
                }
            end

            mini_pick.setup {
                -- Delays (in ms; should be at least 1)
                delay = {
                    -- Delay between forcing asynchronous behavior
                    async = 10,
                    -- Delay between computation start and visual feedback about it
                    busy = 50,
                },

                -- Keys for performing actions. See `:h MiniPick-actions`.
                mappings = {
                    -- caret_left = '<Left>',
                    -- caret_right = '<Right>',

                    -- choose = '<CR>',
                    -- choose_in_split = '<C-s>',
                    -- choose_in_tabpage = '<C-t>',
                    -- choose_in_vsplit = '<C-v>',
                    -- choose_marked = '<M-y>',

                    -- delete_char = '<BS>',
                    -- delete_char_right = '<Del>',
                    delete_left = '<C-c>',
                    -- delete_word = '<C-w>',

                    -- mark = '<C-m>',
                    -- mark_all = '<C-a>',

                    -- move_down = '<C-n>',
                    -- move_start = '<C-g>',
                    -- move_up = '<C-p>',

                    -- paste = '<C-r>',

                    refine = '<C-f>',
                    -- refine_marked = '<M-f>',

                    scroll_down = '<C-d>',
                    -- scroll_left = '<C-h>',
                    -- scroll_right = '<C-l>',
                    scroll_up = '<C-u>',

                    -- stop = '<Esc>',

                    -- toggle_info = '<S-Tab>',
                    -- toggle_preview = '<Tab>',
                },

                -- General options
                options = {
                    -- Whether to show content from bottom to top
                    content_from_bottom = false,
                    -- Whether to cache matches (more speed and memory on repeated prompts)
                    use_cache = false,
                },

                -- Source definition. See `:h MiniPick-source`.
                source = {
                    items = nil,
                    name = nil,
                    cwd = nil,

                    match = nil,
                    show = nil,
                    preview = nil,

                    choose = nil,
                    choose_marked = nil,
                },

                -- Window related options
                window = {
                    -- Float window config (table or callable returning it)
                    config = win_config,
                    -- String to use as cursor in prompt
                    prompt_cursor = '▏',
                    -- String to use as prefix in prompt
                    prompt_prefix = '> ',
                },
            }
            vim.ui.select = mini_pick.ui_select

            vim.keymap.set('n', '<leader>sf', mini_pick.builtin.files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sg', mini_pick.builtin.grep_live, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sw', function()
                local word = vim.fn.expand '<cword>'
                mini_pick.builtin.grep({ pattern = word }, { source = { name = 'Grep: ' .. word } })
            end, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sh', mini_pick.builtin.help, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', mini_extra.pickers.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sn', function()
                mini_pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
            end, { desc = '[S]earch [N]eovim files' })
            vim.keymap.set('n', '<leader>sc', mini_extra.pickers.git_hunks, { desc = '[S]earch [C]hanges' })
            vim.keymap.set('n', '<leader>sr', mini_pick.builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', mini_extra.pickers.oldfiles, { desc = '[S]earch [.]recent Files' })
            vim.keymap.set('n', '<leader>s"', mini_extra.pickers.registers, { desc = '[S]earch ["]registers' })
            vim.keymap.set('n', '<leader><leader>', function()
                -- local wipeout_cur = function()
                --     vim.api.nvim_buf_delete(mini_pick.get_picker_matches().current.bufnr, {})
                -- end
                -- local buffer_mappings = { wipeout = { char = '<C-x>', func = wipeout_cur } }
                -- mini_pick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
                local curr_filepath = vim.api.nvim_buf_get_name(0)
                local is_not_curr_file = function(path_data)
                    return path_data.path ~= curr_filepath and vim.fn.isdirectory(path_data.path) == 0
                end
                mini_extra.pickers.visit_paths({
                    recency_weight = 1.0,
                    filter = is_not_curr_file,
                }, nil)
            end, { desc = '[ ] Search visits' })

            vim.keymap.set('n', '<leader>sv', function()
                mini_extra.pickers.visit_labels({}, nil)
            end, { desc = '[S]earch [V]isit labels' })
        end

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local mini_statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        mini_statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        mini_statusline.section_location = function()
            return '%2l:%-2v'
        end
    end,
}
