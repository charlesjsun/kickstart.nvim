return { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    enabled = true,
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = 'make',

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`

        local telescope = require 'telescope'
        local actions = require 'telescope.actions'
        local action_layout = require 'telescope.actions.layout'

        -- Clone the default Telescope configuration
        -- local vimgrep_arguments = { unpack(require('telescope.config').values.vimgrep_arguments) }
        --
        -- -- I want to search in hidden/dot files.
        -- table.insert(vimgrep_arguments, '--hidden')
        -- -- I don't want to search in the `.git` directory.
        -- table.insert(vimgrep_arguments, '--glob')
        -- table.insert(vimgrep_arguments, '!**/.git/*')

        telescope.setup {
            -- You can put your default mappings / updates / etc. in here
            --  All the info you're looking for is in `:help telescope.setup()`
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    -- '--smart-case',
                    '--ignore-case',
                    '--trim',
                    '--hidden',
                    '--glob',
                    '!**/.git/*',
                },
                preview = {
                    filesize_limit = 10, -- default 25 MB
                },
                mappings = {
                    i = {
                        -- ['<c-enter>'] = actions.to_fuzzy_refine,
                        ['<C-e>'] = { '<esc>', type = 'command' },
                        ['<esc>'] = actions.close,
                        ['<C-y>'] = actions.select_default,
                        ['<C-Space>'] = action_layout.toggle_preview,
                        ['<C-f>'] = actions.to_fuzzy_refine,
                        ['<C-s>'] = actions.select_horizontal,
                        -- ['<C-x>'] = actions.nop,
                    },
                    n = {
                        ['<C-y>'] = actions.select_default,
                        ['<C-c>'] = actions.close,
                        ['<C-Space>'] = action_layout.toggle_preview,
                        ['<C-f>'] = actions.to_fuzzy_refine,
                    },
                },
                dynamic_preview_title = true,
                path_display = {
                    'truncate',
                },
                layout_strategy = 'horizontal',
                sorting_strategy = 'ascending',
                layout_config = {
                    prompt_position = 'top',
                },
            },
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = {
                        'rg',
                        '--files',
                        '--ignore-case',
                        '--hidden',
                        '--glob',
                        '!**/.git/*',
                    },
                },
                buffers = {
                    sort_mru = true,
                    ignore_current_buffer = true,
                    mappings = {
                        i = {
                            ['<C-x>'] = actions.delete_buffer,
                        },
                        n = {
                            ['dd'] = actions.delete_buffer, -- + actions.move_to_top,
                        },
                    },
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'

        -- Normal mode keymaps
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[S]earch [T]reesitter' })
        vim.keymap.set('n', '<leader>sT', builtin.builtin, { desc = '[S]earch [T]elescope builtins' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch [.]recent files' })
        vim.keymap.set('n', '<leader>s"', builtin.registers, { desc = '[S]earch ["]registers' })
        vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = '[S]earch [C]hanges' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Search existing buffers' })

        vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch by grep [/] in Open Files' })

        vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })

        vim.keymap.set('n', '<leader>s~', function()
            builtin.find_files { cwd = vim.fn.expand '$HOME' }
        end, { desc = '[S]earch [~]home directory' })

        -- Visual mode keymaps
        vim.keymap.set('x', '<leader>ss', function()
            local selection = require('csun-waabi.utils').get_curr_visual_selection()
            if selection == nil then
                return
            end
            builtin.grep_string {
                search = selection,
                prompt_title = 'Find Selection (Grep)',
            }
        end, { desc = '[S]earch [S]election' })

        vim.keymap.set('x', '<leader>s/', function()
            local selection = require('csun-waabi.utils').get_curr_visual_selection()
            if selection == nil then
                return
            end
            builtin.grep_string {
                search = selection,
                prompt_title = 'Find Selection in Open Files (Grep)',
                grep_open_files = true,
            }
        end, { desc = '[S]earch selection [/] in Open Files' })
    end,
}
