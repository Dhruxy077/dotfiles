```
                     ██████╗ ██╗  ██╗██████╗ ██╗   ██╗██╗   ██╗██╗███╗   ███╗
                     ██╔══██╗██║  ██║██╔══██╗██║   ██║██║   ██║██║████╗ ████║
                     ██║  ██║███████║██████╔╝██║   ██║██║   ██║██║██╔████╔██║
                     ██║  ██║██╔══██║██╔══██╗██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                     ██████╔╝██║  ██║██║  ██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
                     ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                     D H R U V I M
```

**Dhruvim** is a personal [Neovim](https://neovim.io/) configuration built for speed, comfort, and a
clean development experience. It is fully written in Lua and managed by
[lazy.nvim](https://github.com/folke/lazy.nvim). Feel free to use it as a starting point for your
own config.

Features
--------

- **Fast startup** — lazy-loaded plugins via [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Dashboard** — custom [alpha-nvim](https://github.com/goolord/alpha-nvim) start screen with the
  Dhruvim logo and startup stats
- **File explorer** — [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) with git
  status, buffer, and filesystem views
- **Fuzzy finding** — [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) with
  fzf-native for fast file, grep, and buffer search
- **LSP** — [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) +
  [mason.nvim](https://github.com/williamboman/mason.nvim) with auto-install for Lua, Rust, Python,
  C/C++, Java, TypeScript, HTML, and CSS language servers
- **Completion** — [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with LSP, buffer, path, and
  [LuaSnip](https://github.com/L3MON4D3/LuaSnip) snippet sources
- **Formatting** — [conform.nvim](https://github.com/stevearc/conform.nvim) with per-language
  formatters (stylua, black, rustfmt, prettier, clang-format, and more)
- **Syntax highlighting** — [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  with grammars for Rust, JavaScript/TypeScript, Lua, C/C++, Go, Java, Python, HTML, CSS, and more
- **Statusline** — [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Buffer tabs** — [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- **Terminal** — [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- **Auto-pairs** — [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- **Multiple colorschemes** — Catppuccin, Tokyo Night, Kanagawa, Nightfox, Everforest, Evergarden

Requirements
------------

- [Neovim](https://github.com/neovim/neovim/releases) **≥ 0.10**
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Optional: `make` — required to build the `telescope-fzf-native` extension

Installation
------------

Back up any existing Neovim configuration, then clone this repo into your Neovim config directory:

```bash
# Back up existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone Dhruvim
git clone https://github.com/Dhruxy077/neovim ~/.config/nvim
```

Open Neovim — [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all
plugins automatically on the first launch.

Project layout
--------------

    ~/.config/nvim/
    ├─ init.lua              Entry point — options, keymaps, lazy.nvim bootstrap
    ├─ lazy-lock.json        Plugin version lock file
    └─ lua/
       └─ plugins/           One file per plugin (loaded by lazy.nvim)
          ├─ alpha.lua       Dashboard / start screen
          ├─ autopairs.lua   Auto-pair brackets and quotes
          ├─ bufferline.lua  Buffer tab line
          ├─ completions.lua nvim-cmp completion engine
          ├─ conform.lua     Code formatting
          ├─ lsp-config.lua  LSP servers via Mason
          ├─ lualine.lua     Status line
          ├─ neotree.lua     File explorer
          ├─ telescope.lua   Fuzzy finder
          ├─ toggleterm.lua  Integrated terminal
          ├─ treesitter.lua  Syntax highlighting
          └─ ...             Colorscheme files

Keybindings
-----------

Leader key: `<Space>`

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fc` | Find files in current directory |
| `<leader>fg` | Live grep |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Help tags |
| `<leader>e`  | Toggle file explorer |
| `<leader>ge` | Git status explorer |
| `<leader>be` | Buffer explorer |
| `<leader>cf` | Format injected languages |
| `<leader>df` | Format current buffer |
| `<leader>ca` | LSP code action |
| `<leader>rn` | LSP rename |
| `K`          | LSP hover documentation |
| `gd`         | Go to definition |
| `gD`         | Go to declaration |
| `gr`         | Show references |
| `<C-/>` | Toggle terminal |
| `H` / `L` | Previous / next tab |
| `<C-t>` | New tab |

Colorschemes
------------

Several colorschemes are bundled. Switch between them with `:colorscheme <name>`:

- `catppuccin` (default lualine theme: `carbonfox`)
- `tokyonight`
- `kanagawa`
- `nightfox` / `carbonfox` / `dayfox`
- `everforest`
- `evergarden`

Customisation
-------------

To rename the dashboard from **Dhruvim** to your own name, edit the `logo` variable at the top of
`lua/plugins/alpha.lua` and replace the ASCII art and `D H R U V I M` text with your own.

License
-------

This configuration is provided as-is, free to use and modify for personal use.
