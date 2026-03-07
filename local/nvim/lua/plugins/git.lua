-- lua/plugins/git.lua - Git integration (gitsigns, diffview, neogit)

return {
  -- Gitsigns: Git decorations in the sign column
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          opts.silent = true
          vim.keymap.set(mode, l, r, opts)
        end

        -- Hunk navigation
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Git: Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Git: Previous hunk" })

        -- Hunk actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Git: Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Git: Reset hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: Stage hunk (visual)" })
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Git: Reset hunk (visual)" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: Preview hunk" })
        map("n", "<leader>hb", gs.toggle_current_line_blame, { desc = "Git: Toggle line blame" })
        map("n", "<leader>vb", function() gs.blame_line({ full = true }) end, { desc = "Git: Blame (full commit)" })
      end,
    },
  },

  -- Diffview: Git diff viewer
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {},
  },

  -- Neogit: Magit-style git interface
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = {
        diffview = true,
      },
    },
  },
}
