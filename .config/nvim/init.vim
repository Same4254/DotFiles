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
Plug 'nvim-telescope/telescope.nvim'

Plug 'mfussenegger/nvim-dap'

Plug 'cdelledonne/vim-cmake'
"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'sheerun/vim-polyglot'

"Plug 'prabirshrestha/vim-lsp'
Plug 'rust-lang/rust.vim'
Plug 'mrcjkb/rustaceanvim'

Plug 'rhysd/vim-llvm'
Plug 'justinmk/vim-syntax-extra'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'ray-x/lsp_signature.nvim'

" for haskell
"Plug 'neomake/neomake'
"Plug 'parsonsmatt/intero-neovim'
"Plug 'itchyny/vim-haskell-indent'

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

Plug 'Yggdroot/indentLine'

"Plug 'VonHeikemen/lsp-zero.nvim'
"Plug 'neovim/nvim-lspconfig'
"Plug 'williamboman/mason.nvim'
"Plug 'williamboman/mason-lspconfig.nvim'
"Plug 'hrsh7th/nvim-cmp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-nvim-lua'
Plug 'L3MON4D3/LuaSnip' 
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

vim.diagnostic.config({
  virtual_text = { severity = {min = vim.diagnostic.severity.ERROR}},
  signs = { severity = {min = vim.diagnostic.severity.ERROR}},
  update_in_insert = true,
  underline = { severity = {min = vim.diagnostic.severity.ERROR}},
  severity_sort = false,
  float = true,
})

local actions = require("telescope.actions")
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { enable = true },
  indent = { enable = false }
}

require("telescope").setup({

    defaults = {
	file_ignore_patterns = { "./Debug", "./RelWithDebInfo", "./.stack-work", "./target" },
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

require'lspconfig'.clangd.setup{}

require "lsp_signature".setup({
    on_attach = function(client, bufnr)
        require "lsp_signature".on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = "rounded"
          }
        }, bufnr)
      end,
})

local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
	      cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
	      luasnip.expand_or_jump()
          else
              fallback()
          end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
	      cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
	      luasnip.jump(-1)
	  else
	      fallback()
	  end
      end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'vsnip' }, -- For vsnip users.
            { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
	    { name = 'nvim_lsp_signature_help' },
        }, 
	{{ name = 'buffer' }}
    ),

    snippet = {
        expand = function(args)
	    luasnip.lsp_expand(args.body)
        end,
    }
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['clangd'].setup {
     capabilities = capabilities
  }
EOF


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

set tabstop=8
set shiftwidth=4
set expandtab
"set autoindent
"set smartindent
"inoremap <Tab> <C-V><Tab>
set signcolumn=yes
" filetype indent on

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

nmap <leader>s :wa<CR>

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

nmap <leader>k :lua vim.lsp.buf.hover()<CR>

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
"
