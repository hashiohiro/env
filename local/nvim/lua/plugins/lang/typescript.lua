-- lua/plugins/lang/typescript.lua - TypeScript/JavaScript enhanced support
-- ts_ls is configured in lsp.lua; prettier handles formatting; eslint handles linting

return {
  {
    "pmizio/typescript-tools.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        -- Separate diagnostic codes for ts and js
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
        -- Formatting is handled by prettier via conform.nvim
        tsserver_format_options = {
          allowIncompleteCompletions = false,
        },
      },
    },
  },
}
