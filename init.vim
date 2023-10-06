packloadall

TSEnable highlight
TSEnable incremental_selection
TSEnable indent

set wildoptions=pum
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
"colorscheme jellybeans
colorscheme tokyonight-night
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
set wildignore+=target/**,**/target/**,bin/**,**/bin/**,obj/**,**/obj/**,rocksdb/**,**/rocksdb/**
"nnoremap <S-ScrollWheelUp> <ScrollWheelLeft>
"nnoremap <S-ScrollWheelDown> <ScrollWheelRight>
nnoremap <leader>t :Telescope<CR>
:nnoremap <S-ScrollWheelUp> zH
:nnoremap <S-ScrollWheelDown> zL
:nnoremap <C-ScrollWheelUp> <C-u>
:nnoremap <C-ScrollWheelDown> <C-d> 

"autocmd BufWinLeave *.* mkview!
"autocmd BufWinEnter *.* silent loadview



if exists("g:neovide")
    let g:neovide_transparency = 0.8
    let g:transparency = 0.8
    let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
    let g:terminal_color_4 = 'lightblue'
    let g:neovide_cursor_trail_size = 0.1
endif




lua << EOF
-- Setup language servers.

--require'lspconfig'.fsharp_language_server.setup{}

require('gitsigns').setup()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}
lspconfig.omnisharp.setup {
    cmd = { "dotnet", "/home/gary/.config/nvim/omnisharp/OmniSharp.dll" },

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = false,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,
}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--    vim.keymap.set('n', '<space>wl', function()
--      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--    end, opts)
    vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
