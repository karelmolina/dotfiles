# Minimalist Vim Configuration

A clean, efficient Vim setup using only 8 essential plugins. No bloat, no slow startup, just the essentials you need to be productive.

## Overview

This configuration replaces the bloated 25+ plugin setup with a focused set of 8 carefully chosen plugins that provide 80% of the functionality with 20% of the overhead.

**From 25 plugins down to 8 essentials.**

## Installation on a Fresh Server

### Prerequisites

- Vim 8.0+ or Neovim
- Git
- curl (for Vundle installation)

### Step 1: Backup Existing Configuration

```bash
# Backup existing vim config if present
mv ~/.vimrc ~/.vimrc.backup.$(date +%Y%m%d)
mv ~/.vim ~/.vim.backup.$(date +%Y%m%d) 2>/dev/null || true
```

### Step 2: Install Vundle (Plugin Manager)

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Step 3: Clone Dotfiles

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
```

### Step 4: Create Symlinks

```bash
ln -s ~/dotfiles/vim/vimrc ~/.vimrc
```

### Step 5: Install Plugins

```bash
vim +PluginInstall +qa
```

This will:
- Open Vim
- Run `:PluginInstall` to download and install all 8 plugins
- Quit automatically (`+qa`)

### Step 6: Verify Installation

```bash
vim --version
# Check that plugins loaded:
vim -c "echo 'Vim loaded successfully!'" +qa
```

## Essential Key Bindings

### Leader Key

- **Leader**: `Space`
- **Local Leader**: `,`

### File Explorer (netrw - replaces NERDTree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer on left side |
| `<leader>E` | Open file explorer at current file's directory |

**Inside netrw:**
- `Enter` - Open file or enter directory (netrw closes automatically after opening)
- `t` - Open file in new tab
- `v` - Open file in vertical split
- `o` - Open file in horizontal split
- `-` - Go to parent directory
- `d` - Create new directory
- `D` - Delete file/directory
- `R` - Rename file/directory
- `s` - Cycle sort method
- `i` - Cycle list style

**Note:** netrw automatically closes after opening a file. To keep it open, use `v` or `o` to open splits instead.

### Navigation (vim-sneak)

| Key | Action |
|-----|--------|
| `s{char}{char}` | Sneak forward to 2-character sequence |
| `S{char}{char}` | Sneak backward to 2-character sequence |
| `;` | Repeat last sneak forward |
| `,` | Repeat last sneak backward |
| `f{char}` | Sneak to character forward (enhanced) |
| `F{char}` | Sneak to character backward (enhanced) |
| `t{char}` | Sneak till character forward (enhanced) |
| `T{char}` | Sneak till character backward (enhanced) |

**Example:** `sre` jumps to the next occurrence of "re" (like "return" or "refresh")

### Commenting (vim-commentary)

| Key | Action |
|-----|--------|
| `gcc` | Comment/uncomment current line |
| `gc{motion}` | Comment motion (e.g., `gcip` comments paragraph) |
| `gc` (visual) | Comment selected lines |

**Examples:**
- `gcc` - Toggle comment on current line
- `gc3j` - Comment current line and 3 lines below
- `gcip` - Comment paragraph
- `gcG` - Comment from cursor to end of file

### Surround (vim-surround)

| Key | Action |
|-----|--------|
| `cs"'` | Change surrounding double quotes to single quotes |
| `ds"` | Delete surrounding double quotes |
| `ysiw"` | Add double quotes around inner word |
| `ySiw{` | Add braces around word + indent |
| `S"` (visual) | Surround selection with double quotes |

**Examples:**
- `"Hello world"` → `cs"'` → `'Hello world'`
- `'Hello'` → `ds'` → `Hello`
- `Hello` → `ysiw"` → `"Hello"`
- `<div>Hello</div>` → `cst<p>` → `<p>Hello</p>`

### Git (vim-fugitive)

| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (`:Gstatus`) |
| `<leader>gd` | Git diff current file (`:Gdiff`) |
| `<leader>gb` | Git blame (`:Gblame`) |
| `<leader>gl` | Git log (`:Glog`) |
| `<leader>gc` | Git commit (`:Gcommit`) |
| `<leader>gp` | Git push (`:Gpush`) |

**In `:Gstatus` window:**
- `-` - Stage/unstage file
- `p` - Patch (stage partial changes)
- `cc` - Commit
- `D` - Show diff

### Navigation (vim-unimpaired)

| Key | Action |
|-----|--------|
| `[q` / `]q` | Previous/next quickfix item |
| `[l` / `]l` | Previous/next location list item |
| `[b` / `]b` | Previous/next buffer |
| `[t` / `]t` | Previous/next tag |
| `[<Space>` | Add blank line above |
| `]<Space>` | Add blank line below |
| `[e` / `]e` | Exchange line with above/below |
| `yoh` | Toggle hlsearch |
| `yow` | Toggle wrap |
| `yon` | Toggle line numbers |

### Window Management

| Key | Action |
|-----|--------|
| `<C-h>` | Move to left window |
| `<C-j>` | Move to window below |
| `<C-k>` | Move to window above |
| `<C-l>` | Move to right window |
| `<leader>+` | Increase window width |
| `<leader>-` | Decrease window width |

### General

| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `<leader>r` | Reload vimrc |
| `<leader>h` | Clear search highlights |
| `<leader>w` | Write (save) |
| `<leader>q` | Quit |
| `<C-q>` | Force quit all |
| `<leader>k` | Move line up |
| `<leader>j` | Move line down |
| `<C-t>` | New tab |
| `<leader>tt` | Previous tab |
| `<leader>t` | Next tab |
| `<leader>cn` | Copy filename to clipboard |
| `<leader>cp` | Copy full path to clipboard |

## The 7 Essential Plugins

This configuration uses **7 plugins** plus the built-in `habamax` colorscheme (no plugin needed!).

### 1. vim-polyglot
**Purpose:** Syntax highlighting for 100+ languages
- **Why:** One plugin instead of 20+ individual syntax plugins
- **Config:** Zero configuration needed
- **Docs:** https://github.com/sheerun/vim-polyglot

### 2. vim-commentary
**Purpose:** Toggle comments quickly
- **Why:** Universal commenting with `gcc` and `gc`
- **Key bindings:** `gcc`, `gc{motion}`, `gc` (visual)
- **Docs:** https://github.com/tpope/vim-commentary

### 3. vim-surround
**Purpose:** Manipulate surrounding brackets/quotes
- **Why:** Change, delete, and add surrounding characters
- **Key bindings:** `cs`, `ds`, `ys`, `S` (visual)
- **Docs:** https://github.com/tpope/vim-surround

### 4. vim-fugitive
**Purpose:** Git integration
- **Why:** Best Git wrapper for Vim
- **Key bindings:** `<leader>gs`, `<leader>gd`, `<leader>gb`, etc.
- **Docs:** https://github.com/tpope/vim-fugitive

### 5. vim-unimpaired
**Purpose:** Quick navigation and toggles
- **Why:** Essential `[` and `]` mappings for navigation
- **Key bindings:** `[q/]q`, `[b/]b`, `yoh`, `yow`, etc.
- **Docs:** https://github.com/tpope/vim-unimpaired

### 6. vim-repeat
**Purpose:** Make `.` (dot) work with plugins
- **Why:** Enables repeating surround/commentary actions with `.`
- **Config:** No configuration needed
- **Docs:** https://github.com/tpope/vim-repeat

### 7. habamax (built-in)
**Purpose:** Modern high-contrast color scheme
- **Why:** Native to Vim 8.2+ (no plugin needed!), excellent readability
- **Config:** No configuration needed - just works!
- **Docs:** `:help habamax`

### 8. vim-sneak
**Purpose:** Fast motion with 2-character search
- **Why:** More precise than `/` search, faster than f/F
- **Key bindings:** `s{char}{char}`, `S{char}{char}`, `;`, `,`
- **Docs:** https://github.com/justinmk/vim-sneak

## What Was Removed

The following plugins from the old configuration are no longer needed:

| Removed Plugin | Native Alternative |
|----------------|-------------------|
| NERDTree | netrw (built-in) |
| vim-airline | Native statusline |
| vim-signify | vim-fugitive (built-in signs) |
| vim-multiple-cursors | Visual block mode (`<C-v>`) |
| indentLine | `list` option (if needed) |
| auto-pairs | Manual bracket insertion |
| vim-trailing-whitespace | `autocmd` on save |
| tabline.vim | Native tabline |
| fzf.vim | Built-in `:find` + wildmenu |
| rainbow_parentheses | Not essential |
| vim-cursorword | Not essential |
| matchtagalways | Not essential |
| vim-which-key | Learn the bindings once |
| vim-floaterm | `<C-z>` or tmux |
| Colorizer | Not essential |
| markdown-preview.nvim | Browser preview |
| neocomplete.vim | Built-in omnifunc |
| ALE | Manual linting or use external tools |

## Native Vim Features Used

Instead of plugins, we leverage built-in Vim features:

- **File explorer:** netrw (via `:Lexplore`)
- **Statusline:** Custom native statusline
- **Fuzzy finder:** `:find` with `wildmenu` and `path+=**`
- **Search:** Built-in `/` search with `wildmenu`
- **Autocomplete:** `<C-n>`/`<C-p>` with built-in sources
- **File navigation:** `gf` (go to file), `gx` (open URL)

## Troubleshooting

### Plugin Installation Fails

```bash
# Clean Vundle and reinstall
rm -rf ~/.vim/bundle
rm -rf ~/.vim

# Reinstall Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Reinstall plugins
vim +PluginInstall +qa
```

### Colorscheme Not Loading

```vim
" In Vim, check if habamax is available (Vim 8.2+)
:colorscheme habamax

" If error, your Vim might be too old. Check version:
:version

" For older Vim, use default or install a colorscheme plugin
:colorscheme default
```

### netrw Not Showing Tree View

```vim
" Check netrw settings
:echo g:netrw_liststyle

" Should be 3 for tree view
:let g:netrw_liststyle=3
```

### vim-sneak Not Working

- Make sure you're pressing `s` in **normal mode**, not insert mode
- Check that vim-sneak is installed: `:scriptnames | grep sneak`
- Try `:SneakReset` to clear any stuck state

### Key Bindings Conflicting

```vim
" Check what a key is mapped to
:verbose nmap <leader>e

" Disable a mapping in your ~/.vimrc.local (if you create one)
nunmap <leader>e
```

### Slow Startup

```bash
# Profile startup time
vim --startuptime startup.log +qa
cat startup.log | sort -k2 -n | tail -20

# Common culprits:
# - Large undo files (clean ~/.vim/undodir)
# - Slow shell (set shell=/bin/bash in vim_conf.vim)
# - Too many autocommands
```

### Git Commands Not Working

- Ensure you're in a git repository
- Check `git status` works in terminal
- For `:Gdiff`, ensure you have a diff tool configured:
  ```bash
  git config --global diff.tool vimdiff
  git config --global merge.tool vimdiff
  ```

### Can't Copy to System Clipboard

```vim
" Check clipboard support
:echo has('clipboard')

" If 0 (false), install vim with clipboard support:
" Ubuntu/Debian: sudo apt-get install vim-gtk3
" macOS: brew install vim
" Or use tmux copy mode: prefix+[
```

## Migration Guide

If you're coming from the old 25-plugin configuration:

### NERDTree → netrw

```
NERDTree: <leader>e       →  netrw: <leader>e (same key!)
NERDTree: m + a (create)  →  netrw: % (create file)
NERDTree: m + d (delete)  →  netrw: D (delete)
NERDTree: m + m (move)    →  netrw: R (rename/move)
```

### fzf → :find

```
fzf: <leader>ff           →  Vim: :find <pattern> + Tab
fzf: <leader>fr           →  Vim: :vimgrep /pattern/g **/* + :copen
```

### vim-airline → Native Statusline

The native statusline shows: buffer number, modified flag, full path, filetype, encoding, line/total:column, percentage.

### ALE → External Linters

Run linters in terminal or use:
```vim
:make!          " Run make with error parsing
:copen          " Open error list
[c / ]c         " Navigate errors
```

## Customization

To add your own settings without modifying the repo:

```bash
# Create a local config file
touch ~/.vimrc.local
```

Add to the end of `~/.vimrc`:
```vim
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
```

Example `~/.vimrc.local`:
```vim
" Personal overrides
set number relativenumber

" Change to a different built-in colorscheme
" Other options: blue, darkblue, delek, desert, elflord, evening, industry,
" koehler, morning, murphy, pablo, peachpuff, ron, shine, slate, torte, zellner
colorscheme habamax

" Personal keybindings
nnoremap <leader>ev :e ~/.vimrc.local<CR>
```

## Performance Tips

1. **Lazy loading isn't needed** - With only 8 plugins, startup is fast
2. **Disable unused filetypes** in vim-polyglot if needed
3. **Use `set lazyredraw`** during macros (already enabled)
4. **Reduce updatetime** if cursor feels sluggish (currently 100ms)

## Credits

- Plugin philosophy inspired by [Minimal Vim](https://github.com/romainl/minimal-vim)
- Tim Pope's plugins (commentary, surround, fugitive, unimpaired, repeat)
- Habamax theme (built into Vim 8.2+ by Max)
- Vim-sneak by Justin M. Keyes
- Vim-polyglot by Adam Stankiewicz

## License

This configuration is released into the public domain. Use it, modify it, share it.

---

**Enjoy your minimalist Vim setup!** 🚀