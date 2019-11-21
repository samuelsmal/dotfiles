"
" Custom vim functions
"

" Strips trailing whitespaces while keeping cursor state
function! utils#StripTrailingWhitespace ()
  let save_cursor = getpos('.')
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

function! utils#StripTrailingWhitespaceSilent ()
  let save_cursor = getpos('.')
  let old_query = getreg('/')
  silent! %s/\s\+$//
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

function! utils#ClipboardYank()
  call system('xclip -i -selection clipboard', @@)
endfunction

function! utils#ClipboardPaste()
  let @@ = system('xclip -o -selection clipboard')
endfunction

function! utils#DeinClean()
  echo "Cleaning dein"
  call dein#recache_runtimepath()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
endfunction
