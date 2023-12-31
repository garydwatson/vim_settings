" The default vimrc file.
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
" set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak)
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":autocmd! vimHints"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo |
	  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
	  \ echohl None
  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

packloadall

set wildoptions+=pum
set hlsearch
"let g:netrw_liststyle=3
set nobackup
set expandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set diffopt+=iwhite
set nowrap
set number
"colorscheme torte
"colorscheme murphy
"colorscheme slate
"colorscheme fu
colorscheme jellybeans
"colorscheme mustang
"colorscheme sorcerer
"colorscheme synic
"colorscheme tir_black
"colorscheme xoria256
"colorscheme wombat256mod
"colorscheme lunaperche
"colorscheme tokyonight-night
set guioptions+=b
set tags+=tags;
set showtabline=2
"set undofile
"set undodir=~/tmp
set dir=~/tmp
"set textwidth=120
nnoremap <Leader>n :cn<CR>
nnoremap ]n :lne<CR>
nnoremap <Leader>p :cp<CR>
nnoremap ]p :lpre<CR>
nnoremap <Leader>b :%!git blame %<CR>
set wildignore+=**/target/**,**/bin/**,**/obj/**,**/rocksdb/**,**/.git/**,**/*.dll,**/*.so,**/*.pdb
"nnoremap <S-ScrollWheelUp> <ScrollWheelLeft>
"nnoremap <S-ScrollWheelDown> <ScrollWheelRight>
:nnoremap <S-ScrollWheelUp> zH
:nnoremap <S-ScrollWheelDown> zL
:nnoremap <C-ScrollWheelUp> <C-u>
:nnoremap <C-ScrollWheelDown> <C-d> 
:nnoremap <leader>e :Le<CR>


"autocmd BufWinLeave *.* mkview!
"autocmd BufWinEnter *.* silent loadview

"autocmd WinEnter * setlocal cursorline
"autocmd WinLeave * setlocal nocursorline

"packadd vim-lsp
""""" this is the vim-lsp stuff
"if executable('rustup')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'rust-analyzer',
"        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rust-analyzer']},
"        \ 'allowlist': ['rust'],
"        \ })
"endif
"
"
"if executable('pylsp')
"    " pip install python-lsp-server
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'pylsp',
"        \ 'cmd': {server_info->['pylsp']},
"        \ 'allowlist': ['python'],
"        \ })
"endif
"
"function! s:on_lsp_buffer_enabled() abort
"    setlocal omnifunc=lsp#complete
"    setlocal signcolumn=yes
"    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"    nmap <buffer> gd <plug>(lsp-definition)
"    nmap <buffer> gs <plug>(lsp-document-symbol-search)
"    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
"    nmap <buffer> gr <plug>(lsp-references)
"    nmap <buffer> gi <plug>(lsp-implementation)
"    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
"    nmap <buffer> <leader>rn <plug>(lsp-rename)
"    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
"    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
"    nmap <buffer> K <plug>(lsp-hover)
""    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
""    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
"
""    let g:lsp_format_sync_timeout = 1000
""    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
"    
"    " refer to doc to add more commands
"endfunction
"
"augroup lsp_install
"    au!
"    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
"    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
"augroup END
""""" end this is the vim-lsp stuff





""""" this is the new vim9 lsp
packadd lsp
"packadd vim-lsp-settings
" Rust language server
call LspAddServer([#{
	\    name: 'rustlang',
	\    filetype: ['rust'],
	\    path: '/home/gary/.cargo/bin/rust-analyzer',
	\    args: [],
	\    syncInit: v:true
	\  }])

set omnifunc=lsp#complete
set signcolumn=yes
set tagfunc=lsp#lsp#TagFunc
set keywordprg=:LspHover
""""" end this is the new vim9 lsp



"
"lua << EOF
"-- Setup language servers.
"
"--require'lspconfig'.fsharp_language_server.setup{}
"
"local lspconfig = require('lspconfig')
"lspconfig.pyright.setup {}
"lspconfig.tsserver.setup {}
"lspconfig.rust_analyzer.setup {
"  -- Server-specific settings. See `:help lspconfig-setup`
"  settings = {
"    ['rust-analyzer'] = {},
"  },
"}
"
"
"-- Global mappings.
"-- See `:help vim.diagnostic.*` for documentation on any of the below functions
"vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
"vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
"vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
"vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
"
"-- Use LspAttach autocommand to only map the following keys
"-- after the language server attaches to the current buffer
"vim.api.nvim_create_autocmd('LspAttach', {
"  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
"  callback = function(ev)
"    -- Enable completion triggered by <c-x><c-o>
"    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
"
"    -- Buffer local mappings.
"    -- See `:help vim.lsp.*` for documentation on any of the below functions
"    local opts = { buffer = ev.buf }
"    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
"    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
"    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
"    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
"    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
"    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
"    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
"    vim.keymap.set('n', '<space>wl', function()
"      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
"    end, opts)
"    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
"    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
"    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
"    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
"    vim.keymap.set('n', '<space>f', function()
"      vim.lsp.buf.format { async = true }
"    end, opts)
"  end,
"})
"EOF

