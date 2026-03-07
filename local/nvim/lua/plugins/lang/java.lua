-- lua/plugins/lang/java.lua - Java language support (nvim-jdtls)
-- Actual jdtls configuration is in ftplugin/java.lua

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
  },
}
