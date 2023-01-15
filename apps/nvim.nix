{ pkgs, ... }:

let unstable = import <nixpkgs-unstable> {};
    vim-nginx = unstable.vimUtils.buildVimPlugin {
      name = "nginx-vim";
      src = unstable.fetchFromGitHub {
        owner = "chr4";
        repo = "nginx.vim";
        rev = "a3def0ecd201de5ea7294cf92e4aba62775c9f5c";
        sha256 = "038g7vg6krlpj0hvj3vbhbdiicly8v8zxvhs7an4fa1hr7gdlp4s";
      };
    };

    # put settings in the nix store rather than some wack-ass $HOME-based location
    languageClientSettings = pkgs.writeTextFile {
      name = "settings.json";
      text = builtins.toJSON {
        "rust.clippy_preference" = "on";
      };
    };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    package = pkgs.neovim.override {
      configure = {
        plug.plugins = with unstable.vimPlugins; [
          ale
          ansible-vim
          auto-pairs
          deoplete-nvim
          echodoc-vim
          fzf-vim
          fzfWrapper
          LanguageClient-neovim
          lightline-ale
          lightline-vim
          nerdcommenter
          nerdtree
          palenight-vim
          rainbow
          rust-vim
          tabular
          tagbar
          typescript-vim
          vim-abolish
          vim-flatbuffers
          vim-fugitive
          vim-gitgutter
          vim-indent-guides
          vim-javascript
          vim-json
          vim-jsx-pretty
          vim-nginx
          vim-nix
          vim-rooter
          vim-surround
          vim-terraform
          vimtex
          vim-toml
          vim-trailing-whitespace
          vim-unimpaired
        ];

        customRC = let
          baseConfig = ''
            set cmdheight=1
            set updatetime=300
            set shortmess+=c
            set nobackup
            set nowritebackup
            set termguicolors
            set background=dark
            highlight Pmenu guibg=SteelBlue gui=bold
            set backupdir=$HOME/.vim/backups
            set directory=$HOME/.vimbackup//,/var/tmp//,/tmp//
            set undodir=$HOME/.vim/undodir
            set undofile
            set autochdir
            set clipboard=unnamedplus
            set number
            set laststatus=2
            set nowrap
            set textwidth=0
            set wildignorecase
            " Set to auto read when a file is changed from the outside
            set autoread
            "au FocusGained,BufEnter * checktime
            set autoindent
            set lazyredraw
            set noshowmode
            set shiftwidth=4
            set smarttab
            set softtabstop=4
            set nostartofline
            set showmatch
            set diffopt=filler,iwhite
            set hid
            colorscheme palenight
            if !isdirectory($HOME . "/.vim/undodir")
              call mkdir($HOME . "/.vim/undodir", "p")
            endif
            if !isdirectory($HOME . "/.vim/backups")
              call mkdir($HOME . "/.vim/backups", "p")
            endif
            "window nav
            nnoremap <C-k> <C-w><Up>
            nnoremap <C-j> <C-w><Down>
            nnoremap <C-l> <C-w><Right>
            nnoremap <C-h> <C-w><Left>
            "command mode nav
            cnoremap <C-a> <Home>
            cnoremap <C-e> <End>
            cnoremap <C-p> <Up>
            noremap <C-n> <Down>
            cnoremap <C-b> <Left>
            cnoremap <C-f> <Right>
            "hide searches easily
            noremap <silent> _ :noh<CR>
            "replace easily
            nnoremap <leader>s :%s/\<<C-r><C-w>\>/
            "shift stay
            vnoremap < <gv
            vnoremap > >gv
            vnoremap // y/<C-R>"<CR>
            " Useful mappings for managing tabs
            map <leader>tn :tabnew<cr>
            map <leader>to :tabonly<cr>
            " Let 'tl' toggle between this and the last accessed tab
            let g:lasttab = 1
            nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
            au TabLeave * let g:lasttab = tabpagenr()
            " Opens a new tab with the current buffer's path
            " Super useful when editing files in the same directory
            map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
            autocmd BufRead,BufNewFile *.ipynb setlocal filetype=json
            autocmd BufRead,BufNewFile .condarc setlocal filetype=yaml
            autocmd BufRead,BufNewFile *.pxi,*.pyx,*.pxd setlocal filetype=cython
            autocmd BufRead,BufNewFile *.c,*.cpp,*.c++,*.C,*.h,*.hpp,*.js,*.jsx,*.ts,*.ts.d setlocal tabstop=2 shiftwidth=2
            autocmd BufRead,BufNewFile berglas-* setlocal filetype=toml
            autocmd BufRead,BufNewFile *.fbs setlocal tabstop=2 shiftwidth=2
            autocmd BufRead,BufNewFile *condarc setlocal filetype=yaml
            autocmd BufRead,BufNewFile *.pxi,*.pyx setlocal filetype=pyrex
            autocmd BufRead,BufNewFile *.rkt setlocal filetype=racket
            autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
            autocmd FileType crystal setlocal shiftwidth=2
            autocmd FileType racket setlocal shiftwidth=2
            autocmd BufEnter * silent! lcd %:p:h
            set colorcolumn=80
            highlight ColorColumn ctermbg=blue term=bold
            autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
            autocmd BufWinEnter '__doc__' setlocal bufhidden=delete
            " MacOSX/Linux
            set wildignore+=*/tmp/*,*.so,*.a,*.dylib,*.swp,*.zip,*.gz,*.bz2,*.xz,*.7z,*/__pycache__,__pycache__/*,*.pyc,*.pyo
            " For conceal markers.
            if has('conceal')
              set conceallevel=2 concealcursor=niv
            endif
            if has("autocmd")
              autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
            endif
            " Specify the behavior when switching between buffers
            try
              set switchbuf=useopen,usetab,newtab
              set stal=2
            catch
            endtry
          '';
          standardCognitionConfig = ''
            au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
          '';
          echodocConfig = ''
            set cmdheight=2
            let g:echodoc#enable_at_startup = 1
            let g:echodoc#type = 'signature'
          '';
          deopleteConfig = ''
            let g:deoplete#enable_at_startup = 1
            call deoplete#custom#option('auto_complete', v:false)
            call deoplete#custom#option('sources', {
                    \ 'rust': ['LanguageClient'],
                    \ })
            " Disable the truncate feature.
            call deoplete#custom#source('_', 'max_abbr_width', 0)
            call deoplete#custom#source('_', 'max_menu_width', 0)
            inoremap <silent><expr> <TAB> deoplete#manual_complete()
            function! s:check_back_space() abort "{{{
              let col = col('.') - 1
              return !col || getline('.')[col - 1]  =~ '\s'
            endfunction"}}}
          '';
          languageClientConfig = ''
            set hidden
            let g:LanguageClient_serverCommands = {
                \ 'rust': ['rls'],
                \ 'python': ['pyls'],
            \ }
            let g:LanguageClient_settingsPath = "${languageClientSettings}"
            let g:LanguageClient_diagnosticsEnable = 0
            function SetLSPShortcuts()
              nnoremap <silent> <F5> :call LanguageClient_contextMenu()<CR>
              nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
              nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
              nnoremap <silent> gi :call LanguageClient#textDocument_implementation()<CR>
              nnoremap <silent> <leader>r :call LanguageClient#textDocument_references()<CR>
              nnoremap <silent> <leader>R :call LanguageClient#textDocument_rename()<CR>
              nnoremap <silent> <leader>td :call LanguageClient#textDocument_typeDefinition()<CR>
              nnoremap <silent> <leader>d :call LanguageClient#textDocument_documentSymbol()<CR>
              nnoremap <silent> <leader>n :ALENextWrap<CR>
              nnoremap <silent> <leader>p :ALEPreviousWrap<CR>
              " Rename - rc => rename camelCase
              noremap <leader>rc <silent> :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.camelcase(expand('<cword>'))})<CR>
              " Rename - rs => rename snake_case
              noremap <leader>rs <silent> :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.snakecase(expand('<cword>'))})<CR>
              " Rename - ru => rename UPPERCASE
              noremap <leader>ru <silent> :call LanguageClient#textDocument_rename(
                  \ {'newName': Abolish.uppercase(expand('<cword>'))})<CR>
              " Restart the language server client
              nnoremap <leader>rl :call RestartLanguageClient()<CR>
            endfunction()
            function RestartLanguageClient()
              call LanguageClient#exit()
              sleep 50m
              call LanguageClient#startServer()
              execute 'ALELint'
            endfunction
            augroup LSP
              autocmd!
              autocmd FileType rust,javascript,python call SetLSPShortcuts()
            augroup END
          '';
          aleConfig = ''
            " Always apply ALEFix on save
            let g:ale_fix_on_save = 1
            let g:ale_linters_explicit = 1
            " Using LanguageClient-neovim for completion
            let g:ale_completion_enabled = 0
            let g:ale_linters = {
                \ 'c': ['clangd', 'cppcheck', 'flawfinder'],
                \ 'cpp': ['clangd', 'cppcheck', 'flawfinder'],
                \ 'python': ['bandit', 'pylama', 'vulture'],
                \ 'text': ['mdl', 'proselint', 'languagetool'],
                \ 'markdown': ['mdl', 'proselint', 'languagetool'],
                \ 'rust': ['rls'],
            \ }
            let g:ale_rust_rls_config = {
                \ 'rust': { 'clippy_preference': 'on', }
            \ }
            let g:ale_fixers = {
                \ '*': ['remove_trailing_lines', 'trim_whitespace'],
                \ 'c': ['clang-format'],
                \ 'cpp': ['clang-format'],
                \ 'json': ['fixjson'],
                \ 'python': ['isort', 'autopep8'],
                \ 'rust': ['rustfmt'],
                \ 'sh': ['shfmt'],
            \ }
          '';
          rooterConfig = ''
            " disable auto-vim-rooter
            let g:rooter_use_lcd = 1
            let g:rooter_manual_only = 1
          '';
          fzfConfig = ''
            " define a command which runs ripgrep in the root directory
            " as determined by rooter
            command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . shellescape(<q-args>), 1, {"dir": FindRootDirectory()})
            nnoremap <silent> <leader>fg :Rg<CR>
            command! ProjectFiles execute 'Files' FindRootDirectory()
            nnoremap <silent> <C-p> :ProjectFiles<CR>
            nnoremap <silent> <C-b> :Buffers<CR>
          '';
          pythonConfig = ''
            let g:python_self_cls_highlight = 1
            let g:python_no_parameter_highlight = 1
            let @d='Oimport pdb; pdb.set_trace()  # noqa'
            function! _EscapeText_pyrex(text)
              let result = call("_EscapeText_python", [a:text])
              return result
            endfunction
            augroup python
                autocmd!
                autocmd FileType python
                \   syn keyword pythonSelf self
                \   syn keyword pythonSelf cls
                \ | highlight def link pythonSelf Special
            augroup end
          '';
          tagbarConfig = ''
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
          '';
          indentGuidesConfig = ''
            let g:indent_guides_enable_on_vim_startup = 1
          '';
          rainbowParensConfig = ''
            let g:rainbow_active = 1
          '';
          gitRebaseConfig = ''
            autocmd FileType gitrebase nnoremap <silent> r :Reword<CR><DOWN>
            autocmd FileType gitrebase nnoremap <silent> f :Fixup<CR><DOWN>
            autocmd FileType gitrebase nnoremap <silent> s :Squash<CR><DOWN>
            autocmd FileType gitrebase nnoremap <silent> e :Edit<CR><DOWN>
            autocmd FileType gitrebase nnoremap <silent> p :Pick<CR><DOWN>
            autocmd FileType gitrebase nnoremap <silent> <C-j> :move +1<CR>
            autocmd FileType gitrebase nnoremap <silent> <C-k> :move -2<CR>
          '';
          lightlineConfig = ''
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " => lightline
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            let g:lightline = {
                \ 'colorscheme': 'palenight',
                \ 'active': {
                \   'left': [
                \       ['mode', 'paste'],
                \       ['filename', 'modified']
                \   ],
                \   'right': [
                \       ['lineinfo'],
                \       ['percent'],
                \       ['fileformat', 'fileencoding', 'filetype', 'readonly'],
                \       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok']
                \   ]
                \ },
                \ 'component_expand': {
                \   'linter_checking': 'lightline#ale#checking',
                \   'linter_warnings': 'lightline#ale#warnings',
                \   'linter_errors': 'lightline#ale#errors',
                \   'linter_ok': 'lightline#ale#ok',
                \ },
                \ 'component_type': {
                \   'linter_checking': 'left',
                \   'linter_warnings': 'warning',
                \   'linter_errors': 'error',
                \   'linter_ok': 'left',
                \ }
            \ }
          '';
            in ''
          ${baseConfig}
          ${standardCognitionConfig}
          ${deopleteConfig}
          ${echodocConfig}
          ${languageClientConfig}
          ${aleConfig}
          ${rooterConfig}
          ${fzfConfig}
          ${pythonConfig}
          ${tagbarConfig}
          ${indentGuidesConfig}
          ${rainbowParensConfig}
          ${gitRebaseConfig}
          ${lightlineConfig}
        '';
      };
    };
  };
}
