-- lua/plugins/lsp.lua - LSP configuration (Mason + mason-lspconfig + nvim-lspconfig)

return {
  -- Mason: LSP/DAP/linter/formatter installer
  {
    "williamboman/mason.nvim",
    lazy = false, -- Must load early so mason-lspconfig can find installed servers
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- nvim-lspconfig + mason-lspconfig: LSP server setup
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Diagnostic display settings (new API for Neovim 0.11+)
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "💡",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- Rounded border for hover/signature help
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- LspAttach autocmd: set up LSP keymaps for ALL clients (including jdtls)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local opts = function(desc)
            return { buffer = bufnr, silent = true, desc = "LSP: " .. desc }
          end

          -- Deduplicated go-to-definition
          local function goto_definition()
            local params = vim.lsp.util.make_position_params(0, "utf-16")
            vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx)
              if err or not result or vim.tbl_isempty(result) then
                vim.notify("Definition not found", vim.log.levels.INFO)
                return
              end
              -- Normalize to list
              if not vim.islist(result) then result = { result } end
              -- Deduplicate by uri + range
              local seen = {}
              local unique = {}
              for _, item in ipairs(result) do
                local loc = item.targetUri or item.uri or ""
                local range = item.targetRange or item.range or {}
                local key = loc .. ":" .. vim.inspect(range.start or {})
                if not seen[key] then
                  seen[key] = true
                  unique[#unique + 1] = item
                end
              end
              if #unique == 1 then
                vim.lsp.util.show_document(unique[1], ctx.client and vim.lsp.get_client_by_id(ctx.client_id) and "utf-16" or "utf-16", { focus = true })
              else
                vim.fn.setqflist({}, " ", {
                  title = "Definitions",
                  items = vim.lsp.util.locations_to_items(unique, "utf-16"),
                })
                vim.cmd("copen")
              end
            end)
          end

          vim.keymap.set("n", "gd", goto_definition, opts("Go to definition"))
          vim.keymap.set("n", "<F12>", goto_definition, opts("Go to definition"))
          vim.keymap.set("n", "<S-LeftMouse>", function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true), "n", false)
            vim.schedule(goto_definition)
          end, opts("Go to definition (Shift+Click)"))
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
          vim.keymap.set("n", "gr", function()
            local ok, telescope = pcall(require, "telescope.builtin")
            if ok then
              telescope.lsp_references()
            else
              vim.lsp.buf.references()
            end
          end, opts("References"))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))
        end,
      })

      -- on_attach for mason-lspconfig (kept for capabilities passing)
      local on_attach = function(_, _) end

      -- Capabilities from cmp-nvim-lsp (with pcall fallback)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Per-server custom settings
      local server_settings = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              completion = { callSnippet = "Replace" },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = { typeCheckingMode = "basic" },
            },
          },
        },
        omnisharp = {
          settings = {
            FormattingOptions = { OrganizeImports = true },
            RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
          },
        },
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
          },
        },
        svelte = {
          filetypes = { "svelte" },
          settings = {
            svelte = {
              plugin = {
                typescript = { enable = true },
                svelte = { defaultScriptLanguage = "ts" },
              },
            },
          },
        },
        eslint = {
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
      }

      -- mason-lspconfig: ensure servers installed, then set up each via handlers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "omnisharp",
          "cssls",
          "eslint",
          "svelte",
          "html",
          "jsonls",
          "yamlls",
          "bashls",
          "dockerls",
          "sqlls",
          "angularls",
          -- NOTE: jdtls is NOT here — handled by nvim-jdtls in lang/java.lua
        },
        automatic_installation = true,
        -- handlers: called for EACH installed server, guaranteeing setup runs
        handlers = {
          -- Skip jdtls — handled by nvim-jdtls in ftplugin/java.lua
          ["jdtls"] = function() end,
          -- Skip ts_ls — handled by typescript-tools.nvim
          ["ts_ls"] = function() end,
          -- Default handler for all servers
          function(server_name)
            local config = {
              on_attach = on_attach,
              capabilities = capabilities,
            }
            -- Merge custom settings if defined
            if server_settings[server_name] then
              config = vim.tbl_deep_extend("force", config, server_settings[server_name])
            end
            require("lspconfig")[server_name].setup(config)
          end,
        },
      })

      -- Disable auto-enabled servers that duplicate mason-lspconfig handlers
      vim.lsp.enable("jdtls", false)
      vim.lsp.enable("typescript", false)
    end,
  },
}
