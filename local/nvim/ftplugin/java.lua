-- ftplugin/java.lua - Java configuration (runs automatically on FileType java)
-- This is NOT a Lazy plugin spec; it's a plain Lua file invoked by Neovim's ftplugin mechanism.

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Find project root
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle", ".project" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

-- Workspace directory (unique per project)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Helper: get mason package install path (supports old method and new property)
local function get_mason_path(pkg)
  local ok_path, path = pcall(function() return pkg:get_install_path() end)
  if ok_path then return path end
  return pkg.install_path or ""
end

-- Find jdtls installation via mason
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
local jdtls_path = ""
if mason_registry_ok and mason_registry.is_installed("jdtls") then
  jdtls_path = get_mason_path(mason_registry.get_package("jdtls"))
end
-- Fallback: check common mason install path
if jdtls_path == "" then
  jdtls_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls")
end

-- Determine OS config
local config_dir = jdtls_path .. "/config_linux"
if vim.fn.has("mac") == 1 then
  config_dir = jdtls_path .. "/config_mac"
elseif vim.fn.has("win32") == 1 then
  config_dir = jdtls_path .. "/config_win"
end

-- Find launcher jar
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
  vim.notify("jdtls not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- Extended capabilities for debug
local bundles = {}
local java_debug_path = ""
local java_test_path = ""
if mason_registry_ok then
  if mason_registry.is_installed("java-debug-adapter") then
    java_debug_path = get_mason_path(mason_registry.get_package("java-debug-adapter"))
    local jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
    if jar ~= "" then
      table.insert(bundles, jar)
    end
  end
  if mason_registry.is_installed("java-test") then
    java_test_path = get_mason_path(mason_registry.get_package("java-test"))
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))
  end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Capabilities from cmp-nvim-lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          { name = "JavaSE-17", path = "/usr/lib/jvm/temurin-17-jdk-amd64" },
        },
      },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      format = { enabled = false }, -- Use conform.nvim instead
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "#", "java", "javax", "org", "com" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
        useBlocks = true,
      },
    },
  },
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  on_attach = function(client, bufnr)
    -- Java-specific keymaps (only set if method exists)
    local opts = { buffer = bufnr, silent = true }
    local function jmap(mode, lhs, fn, desc)
      if fn then
        vim.keymap.set(mode, lhs, fn, vim.tbl_extend("force", opts, { desc = desc }))
      end
    end
    jmap("n", "<leader>go", jdtls.organize_imports, "Organize imports")
    jmap("n", "<leader>gc", jdtls.generate_constructor, "Generate constructor")
    jmap("n", "<leader>gt", jdtls.test_nearest_method, "Test nearest method")
    jmap("n", "<leader>gT", jdtls.test_class, "Test class")
    jmap("v", "<leader>ge", jdtls.extract_variable, "Extract variable")
    jmap("v", "<leader>gm", jdtls.extract_method, "Extract method")

    -- Setup DAP for Java (after jdtls is attached)
    pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
    pcall(require, "jdtls.dap") -- setup test runner
  end,
}

jdtls.start_or_attach(config)
