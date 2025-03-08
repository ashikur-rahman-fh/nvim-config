vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

local two_space = 2
local four_space = 4
local curr_indent = two_space

vim.opt.tabstop = curr_indent
vim.opt.softtabstop = curr_indent
vim.opt.shiftwidth = curr_indent
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.undodir = os.getenv("HOME") ..  ".vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

