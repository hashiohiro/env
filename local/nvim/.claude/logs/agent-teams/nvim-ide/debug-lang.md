# Debug-Lang Implementation Log

## Task #3: DAP + Test + Git + Terminal + Language Configs

### Files Created (12 total)

#### Core Plugin Configs (5 files)

1. **lua/plugins/dap.lua** - Debug Adapter Protocol
   - nvim-dap: F5/F10/F11/S-F11 keymaps, breakpoint signs
   - nvim-dap-ui: Auto open/close on debug events, rounded borders
   - nvim-dap-virtual-text: Inline variable display
   - mason-nvim-dap: ensure_installed debugpy, js-debug-adapter, netcoredbg

2. **lua/plugins/neotest.lua** - Test Runner
   - Adapters: neotest-python (pytest), neotest-jest, neotest-dotnet
   - Keys: leader+ts (summary), leader+to (output panel)
   - leader+tr and leader+td handled by keymaps.lua

3. **lua/plugins/git.lua** - Git Integration
   - gitsigns.nvim: Hunk navigation (]c/[c), stage/reset/preview (leader+hs/hr/hp)
   - diffview.nvim: cmd-based lazy loading
   - neogit: cmd-based lazy loading, diffview integration

4. **lua/plugins/terminal.lua** - Terminal
   - toggleterm.nvim: Float direction, rounded borders
   - Lazygit toggle on leader+lg

5. **lua/plugins/overseer.lua** - Task Runner
   - cmd-based lazy loading (OverseerRun, OverseerToggle, OverseerInfo)

#### Language Configs (7 files)

6. **lua/plugins/lang/java.lua** - Plugin spec for nvim-jdtls (ft=java)
7. **ftplugin/java.lua** - Full jdtls config (workspace management, mason integration, debug bundles, Java-specific keymaps)
8. **lua/plugins/lang/typescript.lua** - typescript-tools.nvim (inlay hints, type hints)
9. **lua/plugins/lang/python.lua** - nvim-dap-python (mason debugpy detection, launch configs)
10. **lua/plugins/lang/csharp.lua** - netcoredbg DAP adapter and launch config
11. **lua/plugins/lang/sql.lua** - vim-dadbod + dadbod-ui for database interaction
12. **lua/plugins/lang/scss.lua** - emmet-vim for HTML/CSS productivity

### Design Decisions

- All plugin specs use lazy loading (keys, ft, cmd, event)
- pcall used for all requires that might not be loaded
- Border style "rounded" used consistently
- Java debug/test adapters managed by nvim-jdtls (not mason-nvim-dap)
- Python uses nvim-dap-python plugin for cleaner DAP integration
- TypeScript uses typescript-tools.nvim for enhanced TS experience beyond ts_ls
- Keymaps already defined in keymaps.lua are NOT duplicated in plugin specs

### Keymap Summary (defined in these files)

| Key | Action | File |
|-----|--------|------|
| F5 | dap.continue | dap.lua |
| F10 | dap.step_over | dap.lua |
| F11 | dap.step_into | dap.lua |
| S-F11 | dap.step_out | dap.lua |
| leader+du | Toggle DAP UI | dap.lua |
| leader+ts | Test summary | neotest.lua |
| leader+to | Test output | neotest.lua |
| ]c / [c | Next/prev hunk | git.lua |
| leader+hs | Stage hunk | git.lua |
| leader+hr | Reset hunk | git.lua |
| leader+hp | Preview hunk | git.lua |
| leader+lg | Lazygit | terminal.lua |
| leader+go | Organize imports (Java) | ftplugin/java.lua |
| leader+gc | Generate constructor (Java) | ftplugin/java.lua |
| leader+gt | Test nearest method (Java) | ftplugin/java.lua |
| leader+gT | Test class (Java) | ftplugin/java.lua |
| leader+ge | Extract variable (Java) | ftplugin/java.lua |
| leader+gm | Extract method (Java) | ftplugin/java.lua |

### Status: COMPLETED
