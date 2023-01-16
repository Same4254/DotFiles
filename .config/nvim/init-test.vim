" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = { enable = true }
}
EOF
