local opt = vim.opt

opt.mouse = "a"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true
opt.relativenumber = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.showmatch = true
opt.hlsearch = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.ttimeoutlen = 100
opt.visualbell = true
opt.ruler = true
opt.scrolloff = 2
opt.laststatus = 2
opt.list = true
opt.listchars = { tab = "»·", trail = "·" }
opt.foldenable = false
opt.wildmenu = true
opt.wildmode = "list:longest,full"
opt.showcmd = true
opt.clipboard = "unnamedplus"

-- Split behaviour
opt.splitbelow = true
opt.splitright = true

opt.fillchars:append({ vert = "|" })

opt.autoread = true
opt.mousehide = true

opt.colorcolumn = "100"
opt.textwidth = 100

opt.hidden = true

-- Read theme from ~/.theme-mode (toggle-theme sets this)
local theme_file = vim.fn.expand("~/.theme-mode")
if vim.fn.filereadable(theme_file) == 1 then
  local mode = vim.fn.readfile(theme_file)[1]
  opt.background = (mode == "light") and "light" or "dark"
else
  opt.background = "dark"
end

-- Backup and swap directories
opt.backupdir = { ".backup/", vim.fn.expand("~/.backup/"), "/tmp//" }
opt.directory = { ".swp/", vim.fn.expand("~/.swp/"), "/tmp//" }
opt.undodir = { ".undo/", vim.fn.expand("~/.undo/"), "/tmp//" }
