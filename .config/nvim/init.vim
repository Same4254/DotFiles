" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'kwkarlwang/bufresize.nvim'
Plug 'itchyny/lightline.vim'
"Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }

"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'cdelledonne/vim-cmake'
"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'sheerun/vim-polyglot'

"Plug 'prabirshrestha/vim-lsp'
Plug 'rust-lang/rust.vim'

Plug 'rhysd/vim-llvm'
Plug 'justinmk/vim-syntax-extra'

" for haskell
"Plug 'neomake/neomake'
"Plug 'parsonsmatt/intero-neovim'
Plug 'itchyny/vim-haskell-indent'

Plug 'tikhomirov/vim-glsl'

Plug 'vim-scripts/DoxygenToolkit.vim'

"Plug 'Shougo/deoplete.nvim'
"Plug 'lighttiger2505/deoplete-vim-lsp'

Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
"Plug 'gfanto/fzf-lsp.nvim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'bfrg/vim-cpp-modern'

Plug 'voldikss/vim-floaterm'

"Plug 'Yggdroot/indentLine'

Plug 'VonHeikemen/lsp-zero.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
"Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
"Plug 'L3MON4D3/LuaSnip'
"Plug 'rafamadriz/friendly-snippets'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"set background=dark
"let g:gruvbox_contrast_dark = 'medium'
"let g:gruvbox_contrast_light = 'hard'
"let g:gruvbox_transparent_bg = 1
"autocmd vimenter * ++nested colorscheme gruvbox
autocmd vimenter * ++nested colorscheme dracula
" transparency
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
set termguicolors

"setting with vim-lsp
"if executable('ccls')
"   au User lsp_setup call lsp#register_server({
"      \ 'name': 'ccls',
"      \ 'cmd': {server_info->['ccls']},
"      \ 'root_uri': {server_info->lsp#utils#path_to_uri(
"      \   lsp#utils#find_nearest_parent_file_directory(
"      \     lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json', '.git/']))},
"      \ 'initialization_options': {
"      \   'highlight': { 'lsRanges' : v:true },
"      \   'cache': {'directory': stdpath('cache') . '/ccls' },
"      \ },
"      \ 'whitelist': ['c', 'cpp', 'cu', 'objc', 'objcpp', 'cc'],
"      \ })
"endif

lua <<EOF

local lsp = require('lsp-zero')

lsp.preset('recommended')

require'lspconfig'.hls.setup{}

local cmp_mapping = lsp.defaults.cmp_mappings()

cmp_mapping['<C-k>'] = nil

local opts = {remap = false, silent = true, buffer = bufnr}
vim.keymap.set('n', '<C-k>', '<C-w><Up>', opts)

lsp.setup_nvim_cmp({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
  },
  mapping = cmp_mapping,
  enabled = function()
    local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
    if in_prompt then  -- this will disable cmp in the Telescope window (taken from the default config)
      return false
    end
    local context = require("cmp.config.context")
    return not(context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
  end
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = { severity = {min = vim.diagnostic.severity.ERROR}},
  signs = { severity = {min = vim.diagnostic.severity.ERROR}},
  update_in_insert = false,
  underline = { severity = {min = vim.diagnostic.severity.ERROR}},
  severity_sort = false,
  float = true,
})

local actions = require("telescope.actions")
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { enable = true },
 -- indent = { enable = true }
}

require("telescope").setup({

    defaults = {
		file_ignore_patterns = { "./Debug", "./RelWithDebInfo", "./.stack-work" },
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})
EOF

" Makes fzf close faster
"if has('nvim')
"  aug fzf_setup
"    au!
"    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
"  aug END
"end

"let g:fzf_force_termguicolors = 1
let g:cmake_link_compile_commands = 1
let g:cmake_console_size = 8

" Plugin conflict between barbar and lightline
let g:lightline={ 'enable': {'statusline': 1, 'tabline': 0} }

let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'

let mapleader = " "

set tabstop=4
set shiftwidth=4
set expandtab
"set autoindent
"set smartindent
inoremap <Tab> <C-V><Tab>
set signcolumn=yes
"filetype indent on

"set indentexpr=nvim_treesitter#indent()

"inoremap <Tab> <ESC><C-V><Tab><i>

"map j <Left>
"map k <Up>
"map l <Down>
"
"noremap h ;
"noremap ; h
"
"nmap <C-k> <C-w><Up>
"nmap <C-l> <C-w><Down>
"nmap <C-j> <C-w><Left>
"nmap <C-;> <C-w><Right>
"
"map ; <Right>

nmap <C-s> :w<CR>

" fzf mapping
"nmap <C-f> :Files<CR>

nmap <leader>d :Dox<CR>
nmap <leader>g :CMakeGenerate<CR>
nmap <leader>b :wa<CR> :CMakeBuild<CR>
nmap <leader>q :CMakeClose<CR>

nmap <leader>f :Telescope find_files<CR>
nmap <leader>o :lua require'telescope.builtin'.lsp_document_symbols({symbols = {"class", "function"}})<CR>
nmap <leader>i :lua require'telescope.builtin'.lsp_workspace_symbols({symbols = {"class", "function"}})<CR>
nmap <leader>r :lua require'telescope.builtin'.lsp_references()<CR>

"nmap <leader>o :lua require'telescope.builtin'.lsp_document_symbols()<CR>
"nmap <leader>i :lua require'telescope.builtin'.lsp_workspace_symbols()<CR>
"nmap <leader>r :lua require'telescope.builtin'.lsp_references()<CR>

nmap <leader>n :lua vim.lsp.buf.rename()<CR> 

nmap <C-k> <C-w><Up>
nmap <C-j> <C-w><Down>
nmap <C-h> <C-w><Left>
nmap <C-l> <C-w><Right>

noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

"syntax on
set relativenumber
set number
set cursorline
"set autoindent

augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

set mouse=a
set updatetime=50

" Fixes mouse issues with alacritty
"set ttymouse=sgr


""" ----- COC Config ---- """

"highlight Pmenu ctermbg=gray guibg=gray

" TextEdit might fail if hidden is not set.
"set hidden
"
"" Some servers have issues with backup files, see #649.
"set nobackup
"set nowritebackup
"
"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=50
"
"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
"
"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"if has("nvim-0.5.0") || has("patch-8.1.1564")
"  " Recently vim can merge signcolumn and number column into one
"  set signcolumn=number
"else
"  set signcolumn=yes
"endif
"
"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ CheckBackspace() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! CheckBackspace() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif
"
"" Make <CR> auto-select the first completion item and notify coc.nvim to
"" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call ShowDocumentation()<CR>
"
"function! ShowDocumentation()
"  if CocAction('hasProvider', 'hover')
"    call CocActionAsync('doHover')
"  else
"    call feedkeys('K', 'in')
"  endif
"endfunction
"
"" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)
"
"" Formatting selected code.
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"
"augroup mygroup
"  autocmd!
"  " Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"  " Update signature help on jump placeholder.
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end
"
"" Applying codeAction to the selected region.
"" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap keys for applying codeAction to the current buffer.
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf  <Plug>(coc-fix-current)
"
"" Run the Code Lens action on the current line.
"nmap <leader>cl  <Plug>(coc-codelens-action)
"
"" Map function and class text objects
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
"
"" Remap <C-f> and <C-b> for scroll float windows/popups.
""if has('nvim-0.4.0') || has('patch-8.2.0750')
""  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
""  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
""  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
""  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
""  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
""  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
""endif
"
"" Use CTRL-S for selections ranges.
"" Requires 'textDocument/selectionRange' support of language server.
"nmap <silent> <C-s> <Plug>(coc-range-select)
"xmap <silent> <C-s> <Plug>(coc-range-select)
"
"" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocActionAsync('format')
"
"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
"
"" Add (Neo)Vim's native statusline support.
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
"" Mappings for CoCList
"" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

