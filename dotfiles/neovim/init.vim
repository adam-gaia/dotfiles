" Vim Configuration
" Shoutout to Doug Black for his notes here: https://dougblack.io/words/a-good-vimrc.html
" and to https://coffeeandcontemplation.dev/2021/01/14/autocomplete-in-neovim/


" Significantly speed vim up by changing the regex engine
" see https://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting
" and https://stackoverflow.com/questions/19030290/syntax-highlighting-causes-terrible-lag-in-vim/
set re=1


" --------------------------------------------------
" General
" --------------------------------------------------
set updatetime=100 " Quick updating

" Set the vim tab title = the file name
let &titlestring = @%
set title

set clipboard+=unnamedplus " Copy to the system clipboard

set noerrorbells    " No noise/notification on error
set showmatch       " Highlight matching [{()}]
set number          " show line numbers
set mouse=a         " Allow cursor placement with the mouse
"set cursorline      " Add a line under the cursor
set showcmd         " Show command in bottom bar
set lazyredraw      " Only redraw the screen when needed
set wildmenu        " Visual autocomplete for command menu

set whichwrap+=<,>,[,],h,l        " Make h, l, left/right arrow keys wrap around
set backspace=indent,eol,start    " Back space behaves as expected
packadd termdebug                 " gdb integration with ':Termdebug'
set spell spelllang=en_us         " Spell check

set splitright    " Split vertical windows right to the current windows
set splitbelow    " Split horizontal windows below to the current windows
set autowrite     " Automatically save before :next, :make etc.
set autoread      " Automatically reread changed files without prompting

set scrolloff=8   " Leave 8 lines below the cursor when scrolling


" --------------------------------------------------
" Plugins
" --------------------------------------------------
call plug#begin('~/.vim/plugged')    " Begin Plug plugins

" Nerd font icons
" Lots of other plugings require this one
Plug 'kyazdani42/nvim-web-devicons' 

" Official nvim Language Server Protocol (LSP)
Plug 'neovim/nvim-lspconfig'

" Autocompletion from LSP
Plug 'nvim-lua/completion-nvim'

" Add missing highlight groups for LSP
Plug 'folke/lsp-colors.nvim'

" Trouble - makes LSP issues look nice
Plug 'folke/trouble.nvim'

" Status bar
Plug 'hoob3rt/lualine.nvim'

" Illuminate - highlight current word under cursor
Plug 'RRethy/vim-illuminate'
let g:Illuminate_delay = 100
let g:Illuminate_ftblacklist = ['NvimTree', 'nerdtree']


" Vim/tmux seamless navigation with ctl-h/j/k/l
Plug 'christoomey/vim-tmux-navigator'

let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 2 " autosave when leaving vim buffer
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>


" Debugging with gdb/pdb/bashdb
" Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }


" Theme with Pywal
Plug 'dylanaraps/wal.vim'

" File tree
Plug 'kyazdani42/nvim-tree.lua'
let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile

" Git diff markers
Plug 'airblade/vim-gitgutter'

" Render minimap to preview full file
Plug 'wfxr/minimap.vim'
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1
let g:minimap_highlight_range = 1

call plug#end()    " Initialize plugin system


" --------------------------------------------------
" Configure plugins. Must be after plug#end
" --------------------------------------------------
lua << EOF

  -- Trouble
  require("trouble").setup {
  }

  -- Nvim-tree
  require("nvim-tree").setup {
    auto_open = true,
    -- by default, opens the tree when typing `vim $DIR` or `vim`
    nvim_tree_auto_close = true,
    -- 0 by default, closes the tree when it's the last window
    nvim_tree_follow = true,
    -- 0 by default, this option allows the cursor to be updated when entering a buffer
    nvim_tree_follow_update_path = true
    -- 0 by default, will update the path of the current dir if the file is not inside the tree. Default is 0
  }

  -- Status bar
  require('lualine').setup {
    options = {
      theme = 'molokai'
    }
  }


  --------- LSP ---------
  lspconfig = require('lspconfig')
  completion_callback = require'completion'.on_attach

  -- python
  lspconfig.pyright.setup {
    enabled = true;
    pythonpath = "/usr/local/bin/python";
    on_attach=completion_callback
  }

  -- bash
  --lspconfig.pyright.bashls{
  --  on_attach=completion_callback
  --}

  -- rust
  lspconfig.rust_analyzer.setup{
    on_attach=completion_callback
  }

  -- cmake
  lspconfig.cmake.setup{
    on_attach=completion_callback
  }

  -- ansible
  lspconfig.ansiblels.setup{
    on_attach=completion_callback
  }

  -- c/c++
  lspconfig.clangd.setup{
    on_attach=completion_callback
  }

  -- cmake
  lspconfig.cmake.setup{
    on_attach=completion_callback
  }

  -- docker
  lspconfig.dockerls.setup{
    on_attach=completion_callback
  }

  -- go
  lspconfig.gopls.setup{
    on_attach=completion_callback
  }

  -- html
  lspconfig.html.setup{
    on_attach=completion_callback
  }

  -- json
  lspconfig.jsonls.setup{
    on_attach=completion_callback
  }

  -- yaml
  lspconfig.yamlls.setup{
    on_attach=completion_callback
  }

EOF


" Use <Tab> and <S-Tab> to navigate through completion popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

let g:completion_enable_auto_popup = 0
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)


" --------------------------------------------------
" Cursor - Change thickness by mode
" --------------------------------------------------
" Extra work needs to be done for this to work in tmux
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" --------------------------------------------------
" Search
" --------------------------------------------------
set hlsearch    " Highlight search terms
set incsearch   " search as characters are entered


" --------------------------------------------------
" Indentation
" --------------------------------------------------
set tabstop=4        " Tab visual spacing
set softtabstop=4    " Tab editing spacing
set expandtab        " Insert spaces instead of tabs
set autoindent       "
set shiftwidth=4     " 
set smarttab         "
filetype indent on   " Load filetype-specific indent files # TODO create/find a makefile specific file


" --------------------------------------------------
" Colors
" --------------------------------------------------
syntax on       " Syntax highlighting
colorscheme wal


" ---------- Monokai Color Shortcuts ----------
let s:monokaiBrown = "905532"
let s:monokaiYellow = "ffff87"
let s:monokaiPurple = "af87ff"
let s:monokaiGreen  = "A4E400"
let s:monokaiLightBlue = "62D8F1"
let s:monokaiMagenta = "FC1A70"
let s:monokaiOrange = "FF9700"


" --------------------------------------------------
" Folding
" --------------------------------------------------
set foldenable           " Enable folding
set foldmethod=indent    " Fold based on indent level
set foldlevelstart=5     " Fold anything at level 5+
set foldnestmax=10       " 10 nested fold max


" --------------------------------------------------
" Keybinds
" --------------------------------------------------
" nnoremap <space> za    " space open/closes folds
" TODO: map ':nohlsearch<CR>' to something to toggle search highlights off

" Move vertically through wrapped lines
nnoremap j gj
nnoremap k gk


" --------------------------------------------------
" Autogroups
" --------------------------------------------------
augroup configgroup
    autocmd VimEnter * highlight clear SignColumn
    "autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
    "            \:call <SID>StripTrailingWhitespaces()

    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd FileType python setlocal commentstring=#\ %s
augroup END


" --------------------------------------------------
" Backups
" --------------------------------------------------
set backup    " Create a backup of 'file' to 'file~''

set backupdir=~/tmp/vim-backup/backup//,.    " Backup~ file location
set directory=~/tmp/vim-backup/swp//,.       " Swap file location
set undodir=~/tmp/vim-backup/undo//,.        " Undo file location

set backupskip=/tmp/*,/private/tmp/*,~/tmp/*,~/private/*    " Don't backup these
set writebackup     " Make a backup before overwriting a file
