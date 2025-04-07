vim.cmd("let g:netrw_liststyle=3")
--vim.opt.relativenumber = true
vim.opt.number = true

-- tabs & indentation
vim.opt.tabstop = 3 --2 spaces for tab
vim.opt.shiftwidth = 3 --2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true --copy indentation from current line

vim.opt.wrap = false

--search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true --makes it case sensitive if you add mixed case

vim.opt.cursorline = true

--Theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

--clipboard
vim.opt.clipboard:append("unnamedplus")


