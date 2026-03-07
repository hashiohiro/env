# Neovim IDE Configuration — Design Document

## Project Brief

**Goal**: Transform Neovim into an IntelliJ-like IDE on WSL2, preserving .ideavimrc keybinding philosophy.
**Target languages**: Java, TypeScript, Python, C#, SQL, SCSS
**Colorscheme**: Tokyo Night
**Prerequisites**: Neovim 0.10+, Node.js, JDK 17+, .NET SDK, git, gcc, ripgrep, fd

## Directory Structure

```
/mnt/c/Users/hashi/AppData/Local/nvim/
├── init.lua                          # Bootstrap Lazy.nvim + load config
├── lua/
│   ├── config/
│   │   ├── options.lua               # Vim options
│   │   ├── keymaps.lua               # Keybindings (.ideavimrc based)
│   │   └── autocmds.lua              # Autocommands
│   └── plugins/
│       ├── colorscheme.lua           # Tokyo Night
│       ├── ui.lua                    # lualine, bufferline, indent-blankline, dressing
│       ├── editor.lua                # surround, comment, autopairs, flash, which-key
│       ├── telescope.lua             # telescope + extensions
│       ├── treesitter.lua            # treesitter + textobjects
│       ├── lsp.lua                   # nvim-lspconfig + mason + mason-lspconfig
│       ├── completion.lua            # nvim-cmp + LuaSnip
│       ├── formatting.lua            # conform.nvim
│       ├── neo-tree.lua              # File tree
│       ├── trouble.lua               # Diagnostics panel
│       ├── git.lua                   # gitsigns + diffview + neogit
│       ├── dap.lua                   # nvim-dap + dap-ui + mason-nvim-dap
│       ├── neotest.lua               # neotest + adapters
│       ├── terminal.lua              # toggleterm
│       ├── project.lua               # project.nvim
│       ├── overseer.lua              # task runner
│       └── lang/
│           ├── java.lua              # nvim-jdtls
│           ├── typescript.lua        # ts config
│           ├── python.lua            # pyright + ruff
│           ├── csharp.lua            # omnisharp
│           ├── sql.lua               # sqls
│           └── scss.lua              # cssls
├── ftplugin/
│   └── java.lua                      # jdtls auto-attach
└── README.md
```

## Implementation Phases

- Phase A: Core Foundation (init.lua, options, autocmds, keymaps update)
- Phase B: Essential Plugins (colorscheme, ui, editor, telescope, treesitter)
- Phase C: LSP/Completion/Formatting
- Phase D: IDE Features (neo-tree, trouble, git, terminal, project, overseer)
- Phase E: Debug & Test (dap, neotest)
- Phase F: Language-Specific (java, typescript, python, csharp, sql, scss)
- Phase G: Documentation (README.md)
