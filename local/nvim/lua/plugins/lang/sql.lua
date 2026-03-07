-- lua/plugins/lang/sql.lua - SQL language extras
-- sqls is configured in lsp.lua; sqlfluff formatting is in formatting.lua (conform)
-- Optional: vim-dadbod + dadbod-ui for database interaction

return {
  -- Database UI (optional but highly recommended for SQL workflows)
  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
}
