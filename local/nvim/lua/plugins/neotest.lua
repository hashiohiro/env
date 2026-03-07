-- lua/plugins/neotest.lua - Test runner framework

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "Issafalcon/neotest-dotnet",
    },
    keys = {
      -- leader+tr and leader+td are in keymaps.lua
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Toggle summary panel" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test: Toggle output panel" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
          require("neotest-jest")({
            jestCommand = "npx jest",
          }),
          require("neotest-dotnet"),
        },
        floating = { border = "rounded" },
        output = { open_on_run = true },
        status = { virtual_text = true },
      })
    end,
  },
}
