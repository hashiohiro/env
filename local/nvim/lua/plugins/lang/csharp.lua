-- lua/plugins/lang/csharp.lua - C# language extras
-- omnisharp is configured in lsp.lua; this file adds DAP configuration

return {
  {
    "mfussenegger/nvim-dap",
    ft = "cs",
    config = function()
      local dap_ok, dap = pcall(require, "dap")
      if not dap_ok then
        return
      end

      -- netcoredbg adapter (skip if not installed)
      local netcoredbg = vim.fn.expand("~/.local/share/nvim/mason/packages/netcoredbg/netcoredbg")
      if vim.fn.executable(netcoredbg) ~= 1 then
        return
      end
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }
    end,
  },
}
