-- lua/plugins/formatting.lua - Code formatting with conform.nvim

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        typescript = { "prettier" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        svelte = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        java = { "google-java-format" },
        cs = { "csharpier" },
        sql = { "sqlfluff" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    },
  },
}
