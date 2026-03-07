-- lua/plugins/project.lua - Project detection and management

return {
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = {
          ".git",
          "pom.xml",
          "build.gradle",
          "Makefile",
          "pyproject.toml",
          "*.sln",
          ".project",
        },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
      })

      -- Load telescope extension (if telescope is available)
      local ok, telescope = pcall(require, "telescope")
      if ok then
        pcall(telescope.load_extension, "projects")
      end
    end,
  },
}
