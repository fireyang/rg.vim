

if !exists("g:rg_command")
	let g:rg_command = g:rg_bin . " --vimgrep "
endif

if !exists('g:rg_format')
  let g:rg_format = "%f:%l:%c:%m"
endif

fun! rg#Rg(args) "{{{
    " echo "test2:" a:args . join(a:000, ' ')
    " echo "test3:" expand('%:p')
    " let s:path = expand('<sfile>')
    " let s:path2 = expand('<sfile>:p:h')
    " let s:path = resolve(expand('<sfile>:p'))
    " echo "test3:" s:path2
    " execute "!"g:rg_bin a:args
    " call rg#ShowResults()
    " execute "grep" . " a"
	" call s:RgGrep(a:args)
endfun "}}}

fun! rg#RgGrep(args) "{{{
	let l:grepprgb = &grepprg
	let l:grepformatb = &grepformat
	let &grepprg = g:rg_command
	let &grepformat = g:rg_format
	let l:te = &t_te
	let l:ti = &t_ti
	set t_te=
	set t_ti=

	call s:RgSearch(a:args)

	let &t_te=l:te
	let &t_ti=l:ti
	let &grepprg = l:grepprgb
	let &grepformat = l:grepformatb
endfun "}}}

fun! s:RgSearch(args)
  silent! exe 'grep! ' . a:args
  if len(getqflist())
    copen
    redraw!
    call s:ApplyMappings()
    " call s:Highlight(a:args)
  else
    cclose
    redraw!
    echo "No match found for " . a:args
  endif
endfun

fun! s:ApplyMappings() "{{{
    " execute "nnoremap <buffer> <silent> <CR> <CR>" . l:closemap
    for key_map in items(g:rg_mappings)
      execute printf("nnoremap <buffer> <silent> %s %s", get(key_map, 0), get(key_map, 1))
    endfor
endfun "}}}

fun! s:Highlight(args)
  let @/ = matchstr(a:args, "\\v(-)\@<!(\<)\@<=\\w+|['\"]\\zs.{-}\\ze['\"]")
  call feedkeys(":let &hlsearch=1 \| echo \<CR>", "n")
endfun

