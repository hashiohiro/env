-- lua/plugins/colorscheme.lua - Color scheme configuration

return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = false,
        italic_comment = true,
        show_end_of_buffer = false,
        overrides = {
          -- IntelliJ Dracula-like adjustments
          Normal = { bg = "#282a36" },
          CursorLine = { bg = "#323450" },
          Visual = { bg = "#44475a" },
          Comment = { fg = "#6272a4", italic = true },
          LineNr = { fg = "#6272a4" },
          CursorLineNr = { fg = "#f8f8f2", bold = true },
        },
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
}
