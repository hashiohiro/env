-- lua/plugins/neo-tree.lua - File explorer

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        sources = { "filesystem", "buffers", "git_status" },
        close_if_last_window = true,
        popup_border_style = "rounded",
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          git_status = {
            symbols = {
              added = "✚",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
        },
        commands = {
          copy_absolute_path = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path)
            vim.fn.setreg('"', path)
            vim.notify("Copied: " .. path)
          end,
          copy_relative_path = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local relative = vim.fn.fnamemodify(path, ":.")
            vim.fn.setreg("+", relative)
            vim.fn.setreg('"', relative)
            vim.notify("Copied: " .. relative)
          end,
        },
        window = {
          width = 35,
          position = "left",
          mappings = {
            ["<space>"] = "none",
            ["yy"] = "copy_absolute_path",
            ["Y"] = "copy_relative_path",
          },
        },
        filesystem = {
          group_empty_dirs = true,
          scan_mode = "deep",
          follow_current_file = { enabled = true, leave_dirs_open = true },
          bind_to_cwd = false,
          cwd_target = { sidebar = "global" },
          use_libuv_file_watcher = true,
          async_directory_scan = "never",
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })

      -- Override Neotree command to support Windows paths (C:\foo → /mnt/c/foo)
      vim.api.nvim_create_user_command("Neotree", function(opts)
        local args = opts.args
        -- Convert Windows paths
        args = args:gsub("([A-Za-z]):[/\\]([^%s]*)", function(drive, rest)
          rest = rest:gsub("\\", "/")
          return "/mnt/" .. drive:lower() .. "/" .. rest
        end)
        -- Also change cwd if a directory path is given
        local dir = args:match("^(/[^%s]+)$")
        if dir and vim.fn.isdirectory(dir) == 1 then
          vim.cmd("cd " .. vim.fn.fnameescape(dir))
        end
        require("neo-tree.command")._command(args)
      end, { nargs = "*", force = true })
    end,
  },
}
