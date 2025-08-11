set nu
set ic
set ruler
set smartcase
set nocompatible
filetype off
syntax on
set hls
set background=light
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set cindent
set expandtab
set cursorline
hi CursorLine   cterm=NONE ctermbg=gray ctermfg=NONE
hi CursorColumn cterm=NONE ctermbg=gray ctermfg=NONE
autocmd BufNewFile,BufRead *.tpp set filetype=cpp

map <F4> ms:call AddAuthor()<cr>'s
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
map <F2> :ALEDetail<CR>
noremap - $
noremap ; :
nnoremap <leader>w :w<CR>
nnoremap <leader>e :e<CR>G
inoremap jk <ESC>
nnoremap <leader>1 :set wrap!<CR>
"vmap <leader>a :EasyAlign
vmap <Leader>a <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
if !exists('g:easy_align_delimiters')
  let g:easy_align_delimiters = {}
endif
  let g:easy_align_delimiters['#'] = { 'pattern': '#', 'ignore_groups': ['String'] }

"cpplint modify
function CpplintUpdate()
        execute '%s/\(\/\/.*\)\n \+{/ {  \1/'
        execute '%s/\(\/\/.*\)\n{/ {  \1/'
        execute '%s/\n \+{/ {/'
        execute '%s/\n{/ {/'
        execute '%s/for(/for (/'
        execute '%s/if(/if (/'
        execute '%s/\(\/\/.*\)\n \+else/ else  \1/'
        execute '%s/\(\/\/.*\)\nelse/ else  \1/'
        execute '%s/\n \+else/ else/'
        execute '%s/\nelse/ else/'
        execute '%s/ \+$//'
        execute '%s/ \+;/;/'
        execute '%s/){/) {/'
        execute '/for.*[a-z0-9A-Z_]:[a-zA-Z_]/s/:/ : /'
        execute '%s/\(for.*[a-z0-9A-Z_]\):\([a-zA-Z_]\)/\1 : \2/'
endfunction

"Add author information
function AddAuthor()
        let n=1
        while n < 5
                let line = getline(n)
                if line =~'^\s*\*\s*\S*Last\s*modified\s*:\s*\S*.*$'
                        call UpdateTitle()
                        return
                endif
                let n = n + 1
        endwhile
        call AddTitle()
endfunction
"Add time function
function UpdateTitle()
        normal m'
        execute '/* Last modified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
        normal "
        normal mk
        execute '/* Filename\s*:/s@:.*$@\=": ".expand("%:t")@'
        execute "noh"
        normal 'k
        echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction

"Add head title
function AddTitle()
        call append(0,"/**********************************************************")
        call append(1," * Author        : jiaqi.huo")
        call append(2," * Email         : jiaqi.huo@nio.com")
        call append(3," * Last modified : ".strftime("%Y-%m-%d %H:%M"))
        call append(4," * Filename      : ".expand("%:t"))
        call append(5," * Description   : ")
        call append(6," * *******************************************************/")
        echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction

func SetFuncTitle()
    let funcnodes = matchlist(getline('.'), '\(\(.*\) \)\?\(\(\w*\)::\)\?\(\w\+\)(\(.*\))')
    let retval = funcnodes[2]
    let classname = funcnodes[4]
    let funcname = funcnodes[5]
    let paras = funcnodes[6]

    let title = []
    call add(title ,"/*************************************************************************")

    let funcnametitle = '* function name: '
    if classname != ""
        let funcnametitle = funcnametitle . classname . '::'
    endif
    let funcnametitle = funcnametitle . funcname
    call add(title, funcnametitle)

    if retval == ''
        let retval = 'null'
    endif
    let retvaltitle = "* return: " . retval
    call add(title, retvaltitle)

    let paralist = split(paras, ', ')
    let paratitle = '* parameters: '
    echo paralist
    if paralist == []
        let paratitle = paratitle . 'null'
    endif
    call add(title, paratitle)
    let paraindex = 1
    if paralist != []
        for eachpara in paralist
            let paratitle = '*   #' . paraindex . ': ' . eachpara
            call add(title, paratitle)
            let paraindex += 1
        endfor
    endif

    call add(title, " ************************************************************************/")
    call append(line(".")-1, title)
endfunc

"Add head file define
function AddHDefine()
        let fileNameOrg = expand("%:r")
        let fileName = toupper(expand("%:r"))
        "call append(0,"#ifndef __".expand("%:r")."_H__")
        "call append(1,"#define __".expand("%:r")."_H__")
        call append(0,"#ifndef __".fileName."_H__")
        call append(1,"#define __".fileName."_H__")
        call append(2,"")
        call append(3,"namespace soc {")
        call append(4,"")
        call append(5,"class ".fileNameOrg." {")
        call append(6,"public:")
        call append(line('$'),"")
        call append(line('$'),"};")
        call append(line('$'),"}")
        call append(line('$'),"")
        call append(line('$'),"#endif  // __".fileName."_H__")
        echohl WarningMsg | echo "Successful in adding the headfile define." | echohl None
endfunction

" config ale
let g:ale_linters = {'cpp': ['g++']}
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_cc_options = '-Wall -O2 -std=c99'
let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_c_clang_options = '-Wall -O2 -std=c99'
let g:ale_c_cppcheck_options = '-Wall -O2 -std=c99'
let g:ale_c_clangcheck_options = '-Wall -O2 -std=c99'
let g:ale_c_parse_compile_commands = 1
let g:ale_c_build_dir_names = ['build','.']

let g:ale_cpp_cc_options = '-Wall -O2 -std=c++11'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++11'
let g:ale_cpp_clang_options = '-Wall -O2 -std=c++11'
let g:ale_cpp_cppcheck_options = '-Wall -O2 -std=c++11'
let g:ale_cpp_clangcheck_options = '-Wall -O2 -std=c++11'
let g:ale_cpp_parse_compile_commands = 1
let g:ale_cpp_build_dir_names = ['build','.', '../build/', '../../build/']

"let g:ale_sign_error = "\ue009\ue009"
"hi! clear SpellBad
"hi! clear SpellCap
"hi! clear SpellRare
"hi! SpellBad gui=undercurl guisp=red
"hi! SpellCap gui=undercurl guisp=blue
"hi! SpellRare gui=undercurl guisp=magenta
"
" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

"call vundle#begin()
"" Track the engine.
"Plugin 'SirVer/ultisnips'
"
"" Snippets are separated from the engine. Add this if you want them:
"Plugin 'honza/vim-snippets'
"
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()  

" let Vundle manage Vundle  
" required!   
Bundle 'gmarik/vundle'  

" 可以通过以下四种方式指定插件的来源  
" a) 指定Github中vim-scripts仓库中的插件，直接指定插件名称即可，插件明中的空格使用“-”代替。  
Bundle 'L9'  

" b) 指定Github中其他用户仓库的插件，使用“用户名/插件名称”的方式指定  
Bundle 'rhysd/vim-clang-format'
Bundle 'tpope/vim-fugitive'  
Bundle 'Lokaltog/vim-easymotion'  
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}  
Bundle 'tpope/vim-rails.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'majutsushi/tagbar'
Bundle 'ctrlp.vim'
Bundle 'tomasr/molokai'
Bundle 'Chiel92/vim-autoformat'
Bundle 'bling/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
"Bundle 'neoclide/coc.nvim', {'branch': 'release'}
"Bundle 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = 'your path to .ycm_extra_conf.py'
"colorscheme molokai

" c) 指定非Github的Git仓库的插件，需要使用git地址  
Bundle 'git://git.wincent.com/command-t.git'  

" d) 指定本地Git仓库中的插件  
" Bundle 'file:///Users/gmarik/path/to/plugin'  

" NERD tree
let NERDChristmasTree=0
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos="left"
" Automatically open a NERDTree if no files where specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&
" b:NERDTreeType == "primary") | q | endif
" Open a NERDTree
nmap <F5> :NERDTreeToggle<cr>

" Tagbar
let g:tagbar_width=35
let g:tagbar_autofocus=1
nmap <F6> :TagbarToggle<CR>

" Chiel92/vim-autoformat
noremap <F7> :Autoformat<CR>

" ctrap
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.png,*.jpg,*.jpeg,*.gif " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor
    " Use ag in CtrlP for listing files.
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " Ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
    endif
"
    set laststatus=2 " Always display the status line
    set statusline+=%{fugitive#statusline()} "  Git Hotness
"
let g:airline_powerline_fonts = 1 
" let g:airline_theme="zenburn" " hybrid base16color
let g:airline_theme="term"
set laststatus=2  "永远显示状态栏
let g:airline_powerline_fonts = 1  " 支持 powerline 字体
let g:airline#extensions#tabline#enabled = 1 " 显示窗口tab和buffer
" let g:airline_theme='bubblegum'  " murmur配色不错
if !exists('g:airline_symbols')
let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:coc_disable_startup_warning = 1
filetype plugin indent on     " required!
