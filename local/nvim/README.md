# Neovim IDE Configuration

IntelliJ-like Neovim IDE environment for WSL2, built with Lazy.nvim + Mason.

**Target Languages**: Java, TypeScript, Python, C#, SQL, SCSS

## Prerequisites

### Required

| Tool | Purpose | Install |
|------|---------|---------|
| **Neovim 0.10+** | Editor | `sudo apt install neovim` or build from source |
| **Git** | Plugin management | `sudo apt install git` |
| **Node.js 18+** | LSP servers (Mason) | `curl -fsSL https://deb.nodesource.com/setup_lts.x \| sudo -E bash - && sudo apt install nodejs` |
| **gcc / build-essential** | Treesitter parsers, telescope-fzf-native | `sudo apt install build-essential` |
| **ripgrep** | Telescope live_grep | `sudo apt install ripgrep` |
| **fd-find** | Telescope find_files | `sudo apt install fd-find` |

### Language-Specific

| Tool | Languages | Install |
|------|-----------|---------|
| **JDK 17+** | Java (jdtls) | `sudo apt install openjdk-17-jdk` |
| **.NET SDK** | C# (omnisharp, netcoredbg) | [Microsoft docs](https://learn.microsoft.com/dotnet/core/install/linux) |
| **Python 3.11+** | Python (pyright, debugpy) | `sudo apt install python3 python3-pip` |

### WSL2 Clipboard (Important)

For `clipboard=unnamedplus` to work on WSL2, install `win32yank.exe`:

```bash
# Download win32yank and add to PATH
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
```

### Optional

| Tool | Purpose |
|------|---------|
| **lazygit** | Git TUI (`<leader>lg`) |
| **Nerd Font** | Icons in UI (recommended: JetBrainsMono Nerd Font) |

## Installation

### 1. Place Configuration

This configuration is at `$LOCALAPPDATA/nvim` (Windows). For WSL2 Neovim:

```bash
# Option A: Symlink from WSL2
ln -s /mnt/c/Users/<username>/AppData/Local/nvim ~/.config/nvim

# Option B: Copy to WSL2
cp -r /mnt/c/Users/<username>/AppData/Local/nvim ~/.config/nvim
```

### 2. First Launch

```bash
# Launch Neovim — Lazy.nvim auto-bootstraps and installs plugins
nvim
```

Wait for Lazy.nvim to finish installing all plugins (progress shown in UI).

### 3. Install LSP Servers & Tools

```vim
:Mason
```

Mason will auto-install the configured servers. Verify with `:Mason` that these are installed:

- **LSP**: lua_ls, ts_ls, pyright, omnisharp, sqls, cssls, eslint, jdtls
- **Formatters**: prettier, black, google-java-format, csharpier, stylua, sqlfluff
- **DAP**: debugpy, js-debug-adapter, netcoredbg, java-debug-adapter, java-test

### 4. Install Treesitter Parsers

```vim
:TSUpdate
```

### 5. Verify

```bash
# Headless plugin sync (CI/automation)
nvim --headless "+Lazy sync" +qa

# Check health
nvim +checkhealth
```

## Keybinding Reference

**Leader key: `Space`**

### File Operations

| Key | Action |
|-----|--------|
| `ew` | Save file |
| `eq` | Save and quit |
| `Q` | Force quit |
| `<leader><leader>R` | Reload config |

### Search & Navigation (Telescope)

| Key | IntelliJ Equivalent | Neovim Action |
|-----|---------------------|---------------|
| `<leader>ff` | Find in file | Buffer fuzzy find |
| `<leader>fr` | Replace | Spectre (project replace) |
| `<leader>fa` | Search Everywhere | Telescope builtin picker |
| `<leader>fg` | Find in Path | Live grep |
| `<leader>a` | Goto Action | Command palette |
| `<leader>o` | File Structure (Ctrl+F12) | Document symbols |
| `<leader>za` | Goto File | Find files |
| `<leader>zs` | Goto Symbol | Workspace symbols |
| `<leader>zS` | Goto Class | Dynamic workspace symbols |
| `<leader>zl` | Recent Locations | Jump list |
| `<leader>zL` | Recent Files | Old files |
| `<leader>zp` | Recent Projects | Project picker |
| `<leader>zb` | Last Change | Go to last edit position |
| `<leader>zj` | Back | Jump list back (`<C-o>`) |
| `<leader>zk` | Forward | Jump list forward (`<C-i>`) |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | References |
| `K` / `<leader>k` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>y` | Intention actions (code action) |
| `<leader>p` | Format code (conform.nvim) |
| `<leader>u` | Organize imports |
| `[d` / `]d` | Previous/next diagnostic |
| `[e` / `]e` | Previous/next error |

### IDE Views

| Key | Action |
|-----|--------|
| `<leader>.` | Toggle file tree (Neo-tree) |
| `<leader>t` | Toggle terminal |
| `<leader>lg` | Lazygit (float terminal) |
| `<leader>h` | Zen mode (hide all windows) |
| `<leader>q` | Close buffer |
| `<leader>Q` | Reopen last file |
| `<leader>xx` | Toggle diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xs` | Document symbols (Trouble) |

### Run / Debug / Test

| Key | Action |
|-----|--------|
| `<leader>r` | Run task (Overseer) |
| `<leader>d` | Start/continue debug (DAP) |
| `<leader>;` | Toggle breakpoint |
| `<leader>x` | Stop debug session |
| `<leader>du` | Toggle DAP UI |
| `F5` | Continue |
| `F10` | Step over |
| `F11` | Step into |
| `S-F11` | Step out |
| `<leader>tr` | Run nearest test |
| `<leader>td` | Debug nearest test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Toggle test output |

### Git (VCS)

| Key | Action |
|-----|--------|
| `<leader>vb` | Git blame (line) |
| `<leader>vd` | Diff view |
| `<leader>vs` | File history |
| `<leader>vc` | Neogit (commit UI) |
| `<leader>vp` | Git push |
| `<leader>vl` | Git pull |
| `<leader>vr` | Soft reset last commit |
| `]c` / `[c` | Next/previous git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |

### Code Generation (Java-specific, via jdtls)

| Key | Action |
|-----|--------|
| `<leader>go` | Organize imports |
| `<leader>gc` | Generate constructor |
| `<leader>gt` | Test nearest method |
| `<leader>gT` | Test class |
| `<leader>ge` | Extract variable (visual) |
| `<leader>gm` | Extract method (visual) |

### EasyMotion (Flash.nvim)

| Key | Action |
|-----|--------|
| `s` | Flash jump (normal mode) |
| `S` | Flash treesitter select |
| `<leader>zw` | Flash jump (word) |
| `<leader>z/` | Flash search |
| `<leader>zf` | Flash char |

### Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc{motion}` | Toggle comment (motion) |
| `cs"'` | Change surrounding `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `ys{motion}"` | Add surrounding `"` |
| `O` | Add blank line below |
| `<C-s>` | Substitution template (`%s///gc`) |

### Method Navigation

| Key | Action |
|-----|--------|
| `[m` / `]m` | Previous/next method (treesitter) |
| `af` / `if` | Select function (outer/inner) |
| `ac` / `ic` | Select class (outer/inner) |

## File Structure

```
nvim/
├── init.lua                          # Entry point (Lazy.nvim bootstrap)
├── lua/
│   ├── config/
│   │   ├── options.lua               # Editor options
│   │   ├── keymaps.lua               # All keybindings (.ideavimrc based)
│   │   └── autocmds.lua              # Autocommands
│   └── plugins/
│       ├── colorscheme.lua           # Tokyo Night
│       ├── ui.lua                    # Statusline, bufferline, indent guides
│       ├── editor.lua                # Surround, comment, autopairs, flash, which-key
│       ├── telescope.lua             # Fuzzy finder
│       ├── treesitter.lua            # Syntax highlighting + text objects
│       ├── lsp.lua                   # LSP + Mason
│       ├── completion.lua            # Autocompletion (nvim-cmp)
│       ├── formatting.lua            # Code formatting (conform.nvim)
│       ├── neo-tree.lua              # File explorer
│       ├── trouble.lua               # Diagnostics panel
│       ├── git.lua                   # Git integration
│       ├── dap.lua                   # Debug adapter
│       ├── neotest.lua               # Test runner
│       ├── terminal.lua              # Terminal toggle
│       ├── project.lua               # Project management
│       ├── overseer.lua              # Task runner
│       └── lang/                     # Language-specific configs
│           ├── java.lua              # nvim-jdtls
│           ├── typescript.lua        # typescript-tools.nvim
│           ├── python.lua            # debugpy DAP config
│           ├── csharp.lua            # netcoredbg DAP config
│           ├── sql.lua               # vim-dadbod
│           └── scss.lua              # emmet-vim
└── ftplugin/
    └── java.lua                      # jdtls auto-attach
```

## Troubleshooting

### Clipboard not working on WSL2

Ensure `win32yank.exe` is in your PATH:
```bash
which win32yank.exe  # Should return a path
```

### Mason install failures

```vim
:Mason          " Check install status
:MasonLog       " View install logs
:MasonUpdate    " Update Mason registry
```

Some tools require additional system dependencies:
- `omnisharp` needs .NET SDK
- `jdtls` needs JDK 17+
- `prettier`, `eslint` need Node.js

### jdtls not starting

1. Check JDK: `java -version` (must be 17+)
2. Check Mason: `:Mason` → search for `jdtls` (should show ✓)
3. Open a Java file in a project with `pom.xml` or `build.gradle`
4. Check LSP: `:checkhealth lspconfig` (should show jdtls attached)
5. Check logs: `:lua vim.cmd('edit ' .. vim.lsp.get_log_path())`

### Treesitter parser errors

```vim
:TSUpdate           " Update all parsers
:TSInstall <lang>   " Install specific parser
```

### Icons not showing

Install a Nerd Font and configure your terminal to use it:
- Recommended: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
- Windows Terminal: Settings → Profile → Appearance → Font face

### Slow startup

Check startup time:
```vim
:Lazy profile
```

All plugins use lazy loading. If startup exceeds 100ms, check `:Lazy profile` for the slowest plugins.

## Verification Checklist

After installation, verify each feature:

- [ ] `:Lazy` — Plugin manager opens, all plugins installed
- [ ] `:Mason` — LSP servers/formatters installed
- [ ] `:Telescope find_files` — File picker works
- [ ] Open a `.java` file — jdtls attaches (`:checkhealth lspconfig`)
- [ ] Open a `.ts` file — ts_ls attaches
- [ ] Open a `.py` file — pyright attaches
- [ ] `gd` on a symbol — Jump to definition works
- [ ] `K` on a symbol — Hover documentation shows
- [ ] Save a file — Auto-format runs
- [ ] `<leader>.` — Neo-tree opens
- [ ] `<leader>fg` — Live grep works
- [ ] `<leader>d` on a Python file — Debugger starts
- [ ] `<leader>vc` — Neogit opens
