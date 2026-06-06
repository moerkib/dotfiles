-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Performance & Navigation
vim.opt.lazyredraw = true
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3

-- File Handling
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Display
vim.opt.number = false
vim.opt.laststatus = 2
vim.opt.visualbell = true -- entspricht vb, t_vb= wird in Nvim nicht mehr benötigt

-- --- KEYMAPS & SHORTCUTS ---
vim.g.mapleader = ","

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
-- Autocommand für Git-Commits (Cursor an den Start setzen)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.fn.setpos(".", { 0, 1, 1, 0 })
  end,
})

function _G.RpcXml()
  vim.cmd("silent! %s/></>\\r</g")
  vim.cmd("normal gg=Ggg")
end

function _G.CleanSpecalCharsFromLog()
  vim.cmd("silent! %s/\\%x1b\\[\\d\\d*m//g")
  vim.cmd("silent! %s/\\r//g")
end

-- --- PLUGIN CONFIGURATIONS ---

-- Clone and Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>p", require("telescope.builtin").find_files, {})
      vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, {})
    end,
  },

  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },

  "junegunn/vim-easy-align",
})


-- vim-easy-align Keymaps
map("x", "ga", "<Plug>(EasyAlign)")
map("n", "ga", "<Plug>(EasyAlign)")


