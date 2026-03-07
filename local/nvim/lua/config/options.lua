-- lua/config/options.lua - Editor options for IDE-like experience

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Sign column (always show for LSP/git indicators)
opt.signcolumn = "yes"

-- Cursor
opt.cursorline = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Display
opt.wrap = false
opt.termguicolors = true
opt.conceallevel = 0
opt.fillchars = { eob = " " }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Undo persistence
opt.undofile = true

-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 500

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- System clipboard (WSL2: use clip.exe/powershell.exe instead of win32yank)
opt.clipboard = "unnamedplus"
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Mouse
opt.mouse = "a"
