-- lua/plugins/trouble.lua - Diagnostics and quickfix list (v3)

return {
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      modes = {
        diagnostics = { auto_close = false, auto_open = false },
        symbols = { auto_close = false },
        lsp = { auto_close = false },
        qflist = { auto_close = false },
      },
    },
    keys = {
      { "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>xs", "<Cmd>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
    },
  },
}
