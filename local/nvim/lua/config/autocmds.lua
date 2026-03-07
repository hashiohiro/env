-- lua/config/autocmds.lua - Auto commands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Detect Angular HTML templates (*.component.html → htmlangular filetype)
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("angular_html", { clear = true }),
  pattern = "*.component.html",
  callback = function()
    vim.bo.filetype = "htmlangular"
  end,
})

-- Highlight custom HTML elements (tags with hyphens like <app-card>)
autocmd("FileType", {
  group = augroup("custom_element_highlight", { clear = true }),
  pattern = { "html", "htmlangular", "svelte" },
  callback = function()
    vim.fn.matchadd("Function", "<\\zs[a-z][a-z0-9]*-[a-z0-9-]*\\ze[\\s>]")
    vim.fn.matchadd("Function", "</\\zs[a-z][a-z0-9]*-[a-z0-9-]*\\ze>")
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Resize splits when terminal window is resized
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "man",
    "qf",
    "lspinfo",
    "notify",
    "spectre_panel",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Check if file changed outside of Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Go to last cursor position when opening a file
autocmd("BufReadPost", {
  group = augroup("last_cursor_position", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Convert Windows paths to WSL paths and open in Neo-tree
-- Usage: :NT C:\Users\hashi\Projects\MyApp
vim.api.nvim_create_user_command("NT", function(opts)
  local path = opts.args
  path = path:gsub("([A-Za-z]):[/\\]", function(drive)
    return "/mnt/" .. drive:lower() .. "/"
  end)
  path = path:gsub("\\", "/")
  if vim.fn.isdirectory(path) == 0 then
    vim.notify("Directory not found: " .. path, vim.log.levels.ERROR)
    return
  end
  vim.cmd("cd " .. vim.fn.fnameescape(path))
  require("neo-tree.command").execute({ action = "focus", dir = path })
end, { nargs = 1 })

-- Svelte: jump to component file from <ComponentTag>
autocmd("FileType", {
  group = augroup("svelte_component_jump", { clear = true }),
  pattern = "svelte",
  callback = function(event)
    vim.keymap.set("n", "<F12>", function()
      -- Try LSP first
      local params = vim.lsp.util.make_position_params()
      local results = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)
      if results then
        for _, res in pairs(results) do
          if res.result and #res.result > 0 then
            vim.lsp.buf.definition()
            return
          end
        end
      end
      -- Fallback: find component name under cursor and search import
      local word = vim.fn.expand("<cword>")
      if word:match("^%u") then
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do
          local path = line:match("import%s+" .. word .. "%s+from%s+['\"](.-)['\"]")
            or line:match("import%s+{[^}]*%f[%w]" .. word .. "%f[%W][^}]*}%s+from%s+['\"](.-)['\"]")
          if path then
            if not path:match("%.%w+$") then
              path = path .. ".svelte"
            end
            local dir = vim.fn.expand("%:p:h")
            local full = vim.fn.resolve(dir .. "/" .. path)
            if vim.fn.filereadable(full) == 1 then
              vim.cmd("edit " .. vim.fn.fnameescape(full))
              return
            end
          end
        end
      end
      -- Final fallback: regular LSP definition
      vim.lsp.buf.definition()
    end, { buffer = event.buf, desc = "Svelte: Go to component definition" })
  end,
})

-- Auto-remove trailing whitespace on save (opt-in via buffer variable)
-- Set vim.b.trim_whitespace = true in a buffer to enable
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  callback = function()
    if vim.b.trim_whitespace then
      local save_cursor = vim.fn.getpos(".")
      vim.cmd([[%s/\s\+$//e]])
      vim.fn.setpos(".", save_cursor)
    end
  end,
})
