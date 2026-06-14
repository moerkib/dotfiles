-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Performance & Navigation
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- File Handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

// Keybindings
local map = vim.keymap.set

map("i", "jk", "<Esc>", { silent = true })
map({ "n", "v" }, "<Space>", ":")
map("i", "<C-c>", "<Esc>")
map("v", "//", 'y/<C-R>"<CR>', { silent = true })

map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

map("n", "<C-j>", "<C-w>j")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")


-- --- AUTOCMDS & UTILITIES ---
function _G.RpcXml()
  vim.cmd("silent! %s/></>\\r</g")
  vim.cmd("normal gg=Ggg")
end

function _G.CleanSpecalCharsFromLog()
  vim.cmd("silent! %s/\\%x1b\\[\\d\\d*m//g")
  vim.cmd("silent! %s/\\r//g")
end
