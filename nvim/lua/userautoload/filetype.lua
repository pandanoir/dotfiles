local easy_setup_autocmd = require 'easy-setup-autocmd'
local function add_filetype_autocmd(pattern, command)
  easy_setup_autocmd.setup_autocmd {
    ['BufRead,BufNewFile'] = {
      pattern = pattern,
      command = command
    }
  }
end

add_filetype_autocmd('nginx.conf', 'setf nginx')
add_filetype_autocmd('/etc/nginx/*', 'setf nginx')
add_filetype_autocmd('{,.}{zprofile,zshrc}{,.local}', 'setf zsh')
add_filetype_autocmd('{,.}{bash_profile,bashrc}{,.local}', 'setf bash')
add_filetype_autocmd('*.scss', 'set autoindent noexpandtab tabstop=4 shiftwidth=4')
add_filetype_autocmd('*.vue', 'setlocal commentstring=<!--%s-->')
