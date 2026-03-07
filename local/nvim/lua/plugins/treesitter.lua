-- lua/plugins/treesitter.lua - Syntax highlighting and code understanding

return {
  -- Treesitter: syntax highlighting and code parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Install parsers
      require("nvim-treesitter").setup({
        ensure_installed = {
          "java",
          "typescript",
          "tsx",
          "javascript",
          "python",
          "c_sharp",
          "sql",
          "scss",
          "css",
          "html",
          "json",
          "yaml",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
          "bash",
          "regex",
          "dockerfile",
          "svelte",
        },
      })

      -- Enable treesitter-based highlighting for all supported filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Configure textobjects (separate plugin, new API)
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>s"] = { query = "@parameter.inner", desc = "Swap with next parameter" },
          },
        },
      })
    end,
  },
}
