-- lua/plugins/lang/python.lua - Python language extras
-- pyright is configured in lsp.lua; this file adds DAP and venv detection

return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- Try to find debugpy from mason first, then fall back to system python
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.executable(mason_path) == 1 then
        require("dap-python").setup(mason_path)
      else
        require("dap-python").setup("python")
      end

      -- Additional DAP configurations
      local dap_ok, dap = pcall(require, "dap")
      if dap_ok then
        table.insert(dap.configurations.python, {
          type = "python",
          request = "launch",
          name = "Launch file with args",
          program = "${file}",
          args = function()
            local input = vim.fn.input("Arguments: ")
            return vim.split(input, " ", { trimempty = true })
          end,
        })
      end
    end,
  },
}
