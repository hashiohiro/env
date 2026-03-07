-- lua/plugins/terminal.lua - Terminal integration (toggleterm)

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<leader>tt", "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      {
        "<leader>lg",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local lazygit = Terminal:new({
            cmd = "lazygit",
            direction = "float",
            hidden = true,
            float_opts = { border = "rounded" },
          })
          lazygit:toggle()
        end,
        desc = "Toggle lazygit",
      },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return 80
        end
      end,
      direction = "float",
      float_opts = { border = "rounded" },
      shade_terminals = true,
      on_open = function(term)
        -- Esc でターミナルモードからノーマルモードへ
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr })
        -- Ctrl+v でクリップボードからペースト（ターミナルモード）
        vim.keymap.set("t", "<C-v>", function()
          local content = vim.fn.getreg("+")
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n", false)
          vim.schedule(function()
            vim.api.nvim_put({ content }, "", false, true)
            vim.cmd("startinsert")
          end)
        end, { buffer = term.bufnr })
      end,
    },
  },
}
