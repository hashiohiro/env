-- lua/config/keymaps.lua - Key mappings (based on .ideavimrc patterns)

-- Safe require helper: returns module or nil if not available
local function safe_require(mod)
  local ok, m = pcall(require, mod)
  if ok then return m end
  return nil
end

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- -------------------------
-- Basic movement (.ideavimrc style)
-- -------------------------

-- j/k on display lines (with count uses real lines)
map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end, { expr = true })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end, { expr = true })
map("n", "<Up>", "gk")
map("n", "<Down>", "gj")

-- O: add blank line below and stay in normal mode
map("n", "O", "o<Esc>")

-- Substitution template
map("n", "<C-s>", ":%s///gc<Left><Left><Left><Left>", { silent = false })

-- Paste behavior (adjusted indentation)
map("n", "p", "]p")
map("n", "P", "]P")
map("n", "]p", "p")
map("n", "]P", "P")

-- -------------------------
-- File operations (ew/eq/Q)
-- -------------------------
map("n", "ew", function()
  if vim.fn.expand("%") ~= "" then
    vim.cmd("w")
  else
    vim.notify("No file name", vim.log.levels.WARN)
  end
end, { desc = "Save file" })
map("n", "eq", function()
  if vim.fn.expand("%") ~= "" then
    vim.cmd("wq")
  else
    vim.cmd("q")
  end
end, { desc = "Save and quit" })
map("n", "Q", "<Cmd>q!<CR>")

-- Reload config
map("n", "<leader><leader>R", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Reloaded init.lua", vim.log.levels.INFO)
end)

-- -------------------------
-- Error / Method navigation
-- -------------------------
map("n", "[e", vim.diagnostic.goto_prev)
map("n", "]e", vim.diagnostic.goto_next)

-- Toggle diagnostic severity (errors only ↔ all)
local diag_show_all = true
map("n", "<leader>xw", function()
  diag_show_all = not diag_show_all
  if diag_show_all then
    vim.diagnostic.config({ virtual_text = { spacing = 4, prefix = "●" }, signs = true, underline = true })
    vim.notify("Diagnostics: ALL", vim.log.levels.INFO)
  else
    local severity = { min = vim.diagnostic.severity.ERROR }
    vim.diagnostic.config({ virtual_text = { spacing = 4, prefix = "●", severity = severity }, signs = { severity = severity }, underline = { severity = severity } })
    vim.notify("Diagnostics: ERRORS only", vim.log.levels.INFO)
  end
end, { desc = "Toggle diagnostic severity" })

-- [m / ]m for method navigation (treesitter-textobjects expected)
map("n", "[m", function() vim.cmd("normal! [m") end)
map("n", "]m", function() vim.cmd("normal! ]m") end)

-- -------------------------
-- Search / Structure / Completion (leader keys)
-- -------------------------

-- Buffer search
map("n", "<leader>ff", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")

-- Project-wide replace (Spectre)
map("n", "<leader>fr", function()
  local spectre = safe_require("spectre")
  if spectre then spectre.toggle() end
end)

-- Search everything
map("n", "<leader>fa", "<Cmd>Telescope builtin<CR>")
map("n", "<leader>fg", "<Cmd>Telescope live_grep<CR>")

-- Action search (commands/keymaps)
map("n", "<leader>a", "<Cmd>Telescope commands<CR>")

-- QuickDoc (hover)
map("n", "<leader>k", vim.lsp.buf.hover)

-- Document symbols (Ctrl+F12 equivalent)
map("n", "<leader>o", "<Cmd>Telescope lsp_document_symbols<CR>")

-- Format (Reformat)
map({ "n", "v" }, "<leader>p", function()
  local conform = safe_require("conform")
  if conform then
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 5000 })
  end
end)

-- Organize imports
map("n", "<leader>u", function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports", "source.fixAll" } }
  vim.lsp.buf.code_action(params)
end)

-- Close buffer
map("n", "<leader>q", "<Cmd>bdelete<CR>")

-- Restore last closed buffer (uses bufferline if available)
map("n", "<leader>Q", function()
  local bl = safe_require("bufferline")
  if bl then
    -- bufferline doesn't have a direct "restore" API;
    -- use oldfiles as a fallback to reopen the most recent file
    local oldfiles = vim.v.oldfiles
    if oldfiles and #oldfiles > 0 then
      vim.cmd("edit " .. vim.fn.fnameescape(oldfiles[1]))
    end
  end
end)

-- Terminal / Project view
map("n", "<leader>tt", "<Cmd>ToggleTerm<CR>")
map("n", "<leader>.", "<Cmd>Neotree toggle<CR>")

-- Code action (Intention actions)
map("n", "<leader>y", vim.lsp.buf.code_action)

-- HideAllWindows equivalent: close all side panels (neo-tree, trouble, dap-ui, etc.)
map("n", "<leader>H", function()
  pcall(vim.cmd, "Neotree close")
  pcall(vim.cmd, "Trouble close")
  pcall(vim.cmd, "DiffviewClose")
  pcall(function() require("dapui").close() end)
  pcall(vim.cmd, "OverseerClose")
  vim.cmd("only")
end, { desc = "Hide all windows" })

-- Clear search highlight
map("n", "<leader><CR>", "<Cmd>nohlsearch<CR>")

-- -------------------------
-- Navigation (z-prefix)
-- -------------------------

-- Workspace symbols
map("n", "<leader>zs", "<Cmd>Telescope lsp_workspace_symbols<CR>")
map("n", "<leader>zS", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>")

-- Jump list back/forward
map("n", "<leader>zj", "<C-o>")
map("n", "<leader>zk", "<C-i>")

-- Recent locations / files
map("n", "<leader>zl", "<Cmd>Telescope jumplist<CR>")
map("n", "<leader>zL", "<Cmd>Telescope oldfiles<CR>")

-- Last edit position
map("n", "<leader>zb", "g;")

-- Find files (GotoFile)
map("n", "<leader>za", "<Cmd>Telescope find_files<CR>")

-- Recent projects
map("n", "<leader>zp", "<Cmd>Telescope projects<CR>")

-- Flash.nvim mappings (EasyMotion replacement)
map("n", "<leader>zw", function()
  local flash = safe_require("flash")
  if flash then flash.jump() end
end, { desc = "Flash jump" })

map("n", "<leader>z/", function()
  local flash = safe_require("flash")
  if flash then flash.jump({ search = { mode = "search" } }) end
end, { desc = "Flash search" })

map("n", "<leader>zf", function()
  local flash = safe_require("flash")
  if flash then flash.jump({ search = { mode = "exact" }, label = { after = false, before = true } }) end
end, { desc = "Flash char" })

-- -------------------------
-- Run / Debug / Test
-- -------------------------

-- Run (Overseer task picker)
map("n", "<leader>r", "<Cmd>OverseerRun<CR>")

-- Debug (DAP)
map("n", "<leader>dc", function()
  local dap = safe_require("dap")
  if dap then dap.continue() end
end)

-- Toggle breakpoint
map("n", "<leader>;", function()
  local dap = safe_require("dap")
  if dap then dap.toggle_breakpoint() end
end)

-- Stop debug session
map("n", "<leader>dx", function()
  local dap = safe_require("dap")
  if dap then dap.terminate() end
end)

-- Test (neotest)
map("n", "<leader>tr", function()
  local neotest = safe_require("neotest")
  if neotest then neotest.run.run() end
end)

map("n", "<leader>td", function()
  local neotest = safe_require("neotest")
  if neotest then neotest.run.run({ strategy = "dap" }) end
end)

-- -------------------------
-- Git (leader v*)
-- -------------------------
map("n", "<leader>vb", function()
  local gs = safe_require("gitsigns")
  if gs then gs.blame_line({ full = true }) end
end)

map("n", "<leader>vd", "<Cmd>DiffviewOpen<CR>")
map("n", "<leader>vs", "<Cmd>DiffviewFileHistory %<CR>")

-- lazygit (vc/vp/vl all open lazygit)
local function lazygit_open()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true,
    float_opts = { border = "rounded" },
  })
  lazygit:toggle()
end
map("n", "<leader>vc", lazygit_open, { desc = "lazygit" })
map("n", "<leader>lg", lazygit_open, { desc = "lazygit" })
map("n", "<leader>vp", "<Cmd>!git push<CR>", { desc = "Git push", silent = false })
map("n", "<leader>vl", "<Cmd>!git pull<CR>", { desc = "Git pull", silent = false })

-- Soft reset last commit (use with caution)
map("n", "<leader>vr", "<Cmd>!git reset --soft HEAD~1<CR>", { silent = false })
