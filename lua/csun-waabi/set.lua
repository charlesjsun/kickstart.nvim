--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocaleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
vim.opt.number = true
--  Unfortunately disable this to decrease latency over SSH
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- enable mouse for 'a'll modes
vim.opt.mouse = 'a'

-- Don't show the mode, since it"s already in the status line
vim.opt.showmode = false

vim.opt.breakindent = true

vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C
vim.opt.ignorecase = true
vim.opt.smartcase = false

vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Increases timeoutlen cos I'm bad
vim.opt.timeoutlen = 2000

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 12

-- Recommended by https://github.com/rmagatti/auto-session
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Colors in tmux https://www.cyfyifanchen.com/blog/neovim-true-color
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- vim.opt.guicursor =
--     'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175'
