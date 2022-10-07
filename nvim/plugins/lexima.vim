function! s:as_list(a)
  return type(a:a) == type([]) ? a:a : [a:a]
endfunction
function! s:add_ignore_rule(rule)
  let rule = copy(a:rule)
  let rule.input = rule.char
  let rule.input_after = ""
  call lexima#add_rule(rule)
endfunction

function! s:add_rule(rule, ...)
  call lexima#add_rule(a:rule)
  if a:0 == 0
    return
  endif

  for ignore in s:as_list(a:1)
    call s:add_ignore_rule(extend(copy(a:rule), ignore))
  endfor
endfunction

" 第二引数に無視する条件の rule を渡す
call lexima#add_rule({'at': '\[\%#\]', 'char': '<Space>', 'leave': ' '})
call s:add_rule({'char': '(', 'input_after': ')'},[{'at': '\%#\w'},{'syntax' : 'Comment'},{'syntax' : 'String'}])
call s:add_rule({'char': '[', 'input_after': ']'},[{'at': '\%#\w'},{'syntax' : 'Comment'},{'syntax' : 'String'}])
call s:add_rule({'char': '{', 'input_after': '}'},[{'at': '\%#\w'},{'syntax' : 'Comment'},{'syntax' : 'String'}])
call s:add_rule({'char': '`', 'input_after': '`'},[{'at': '\%#\w'},{'syntax' : 'Comment'},{'syntax' : 'String'}])
