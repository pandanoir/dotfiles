function addFiletypeAutocmd(pattern, command)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = 'MyAutoCmd',
    pattern = pattern,
    command = command
  })
end

addFiletypeAutocmd('nginx.conf', 'setf nginx')
addFiletypeAutocmd('/etc/nginx/*', 'setf nginx')
addFiletypeAutocmd('*/zsh/functions/*,{,.}{zprofile,zshrc}{,.local}', 'setf zsh')
addFiletypeAutocmd('{,.}{bash_profile,bashrc}{,.local}', 'setf bash')
addFiletypeAutocmd('*.scss', 'set autoindent noexpandtab tabstop=4 shiftwidth=4')
