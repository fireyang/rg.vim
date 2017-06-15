if exists('g:loaded_rg') || &cp
  finish
endif

if !exists("g:rg_plugin_path")
    if exists("g:vundle#bundle_dir")
        let g:rg_plugin_path = g:vundle#bundle_dir."/rg.vim"
    endif
    " if executable('rg')
endif

let s:bin_path = g:rg_plugin_path."/bin"
if !isdirectory(s:bin_path) 
    call mkdir(s:bin_path)
endif
let g:rg_bin = s:bin_path."/rg"

if !exists("g:rg_mappings")
    let g:rg_mappings = {
          \ "t": "<C-W><CR><C-W>T",
          \ "T": "<C-W><CR><C-W>TgT<C-W>j",
          \ "o": "<CR>",
          \ "O": "<CR><C-W>p<C-W>c",
          \ "go": "<CR><C-W>p",
          \ "h": "<C-W><CR><C-W>K",
          \ "H": "<C-W><CR><C-W>K<C-W>b",
          \ "v": "<C-W><CR><C-W>H<C-W>b<C-W>J<C-W>t",
          \ "gv": "<C-W><CR><C-W>H<C-W>b<C-W>J" }
endif

function! rg#Down()
    if !filereadable(g:rg_bin)
        let s:file = "https://github.com/BurntSushi/ripgrep/releases/download/0.5.2/ripgrep-0.5.2-x86_64-unknown-linux-musl.tar.gz"
        let s:out_file = s:bin_path."/rg.tar.gz"
        echo "start down ripgrep"
        if !filereadable(s:out_file) 
            if executable('wget')
                silent execute "!wget ".s:file." -O " . s:out_file
            elseif executable('curl')
                execute "!curl -L ".s:file." > ".s:bin_path."/rg.tar.gz"
            end
        end
        silent execute "!tar -xvf ". s:out_file . " -C " . s:bin_path 
        silent execute "!cp ripgrep*/rg ."
        silent execute "!rm -r ripgrep*"
    endif
endfunction


command! -bang -nargs=* -complete=file Rg           call rg#RgGrep(<q-args>)
command! -bang -nargs=* -complete=file RgDown       call rg#Down()

let g:loaded_ack = 1
