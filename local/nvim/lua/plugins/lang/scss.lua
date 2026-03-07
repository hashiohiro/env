-- lua/plugins/lang/scss.lua - SCSS/CSS language extras
-- cssls is configured in lsp.lua; prettier formatting is in formatting.lua (conform)

return {
  -- Emmet for rapid HTML/CSS editing
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "typescriptreact", "javascriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-e>"
    end,
  },
}
