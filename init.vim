packloadall

set scrollback=100000
set foldcolumn=1
set diffopt+=iwhite
set number
set nowrap
set shiftwidth=4
set tabstop=4
set expandtab
"colorscheme torte
"colorscheme murphy
"colorscheme slate
"colorscheme fu
"colorscheme jellybeans
"colorscheme mustang
"colorscheme sorcerer
"colorscheme synic
"colorscheme tir_black
"colorscheme xoria256
"colorscheme wombat256mod
"colorscheme lunaperche
colorscheme habamax
"colorscheme tokyonight-night
set showtabline=2
"set undofile

set wildignore+=**/node_modules/**,**/target/**,**/bin/**,**/obj/**,**/rocksdb/**,**/.git/**,**/*.dll,**/*.so,**/*.pdb,**/packages/**
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

":NvimTreeResize 50

nnoremap <Leader>n :cn<CR>
nnoremap ]n :lne<CR>
nnoremap <Leader>p :cp<CR>
nnoremap ]p :lpre<CR>
nnoremap <Leader>b :%!git blame %<CR>
"nnoremap <S-ScrollWheelUp> <ScrollWheelLeft>
"nnoremap <S-ScrollWheelDown> <ScrollWheelRight>
nnoremap <leader>t :Telescope builtin include_extensions=true<CR>
:nnoremap <S-ScrollWheelUp> zH
:nnoremap <S-ScrollWheelDown> zL
:nnoremap <C-ScrollWheelUp> <C-u>
:nnoremap <C-ScrollWheelDown> <C-d> 
":nnoremap <leader>e :NvimTreeToggle<CR>

menu PopUp.Hover K
menu PopUp.Goto\ References :lua vim.lsp.buf.references()<CR>
menu PopUp.Goto\ Type\ Definition <C-]>
unmenu PopUp.How-to\ disable\ mouse

"autocmd BufWinLeave *.* mkview!
"autocmd BufWinEnter *.* silent loadview

"autocmd WinEnter * setlocal cursorline
"autocmd WinLeave * setlocal nocursorline

if exists("g:neovide")
    let g:neovide_transparency = 0.98
    let g:transparency = 0.98
"    let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))
    let g:terminal_color_4 = 'lightblue'
"    set guifont=Hack:h10
    let g:neovide_position_animation_length = 0
    let g:neovide_cursor_animation_length = 0.00
    let g:neovide_cursor_trail_size = 0
    let g:neovide_cursor_animate_in_insert_mode = 0
    let g:neovide_cursor_animate_command_line = 0
    let g:neovide_scroll_animation_far_lines = 0
    let g:neovide_scroll_animation_length = 0.00
    let g:neovide_scale_factor = 0.7
endif

lua << EOF

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
--vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "ii14/lsp-command",
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/gitsigns.nvim",
    -- "ionide/Ionide-vim",
    "will133/vim-dirdiff",
    "uguu-org/vim-matrix-screensaver",
    "folke/tokyonight.nvim",
    "folke/which-key.nvim",
    "David-Kunz/gen.nvim",
    "nvim-lua/plenary.nvim",
    -- "magicalne/nvim.ai",
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

-- require('ai').setup({
--   provider = "ollama",
--   ollama = {
--     model = "llama3.1:8b-instruct-q8_0", -- You can start with smaller one like `gemma2` or `llama3.1`
--     --endpoint = "http://192.168.2.47:11434", -- In case you access ollama from another machine
--   }
-- })

require('gen').setup({
--    opts = {
        model = "llama3.1:8b-instruct-q8_0", -- The default model to use.
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        display_mode = "horizontal-split", -- The display mode. Can be "float" or "split" or "horizontal-split".
        show_prompt = false, -- Shows the prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = false, -- Never closes the window automatically.
        hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
        init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
        -- Function to initialize Ollama
        command = function(options)
            local body = {model = options.model, stream = true}
            return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
        end,
        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        debug = false -- Prints errors and the command which is run.
--    }
})

vim.keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')

require("mason").setup()
require("mason-lspconfig").setup()
require'lspconfig'.omnisharp.setup{}
require'lspconfig'.jdtls.setup{}
--require'lspconfig'.jdtls.setup{ 
----    cmd = { "java", "-javaagent:$HOME/.local/share/nvim/mason/share/jdtls/lombok.jar" },
--    init_options = {
--        jvm_args = { "-javaagent:$HOME/.local/share/nvim/mason/share/jdtls/lombok.jar" },
--        workspace = "/home/user/.cache/jdtls/workspace",
--    },
--}
require'lspconfig'.fsharp_language_server.setup{}
require('gitsigns').setup()
require('lspconfig').pyright.setup {}
require('lspconfig').gleam.setup {}
require('lspconfig').tsserver.setup {
  -- settings = {
  --   typescript = {
  --     preferences = {
  --       importModuleSpecifier = "relative"
  --     },
  --   },
  -- },
  -- init_options = {
  --   preferences = {
  --     importModuleSpecifierPreference = 'non-relative',
  --   },
  -- },
}
require('lspconfig').rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {},
  },
}
require('lspconfig').bufls.setup {}
--require'lspconfig'.ruby_lsp.setup{}
--require'lspconfig'.sorbet.setup{}
require'lspconfig'.html.setup{}


vim.lsp.inlay_hint.enable()

EOF

TSEnable highlight
TSEnable incremental_selection
TSEnable indent
