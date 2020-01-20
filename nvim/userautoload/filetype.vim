autocmd MyAutoCmd BufRead,BufNewFile /etc/nginx/* setf nginx
autocmd MyAutoCmd BufRead,BufNewFile nginx.conf setf nginx
autocmd MyAutoCmd BufRead,BufNewFile */zsh/functions/*,{,.}{zprofile,zshrc}{,.local} setf zsh
autocmd MyAutoCmd BufRead,BufNewFile {,.}{bash_profile,bashrc}{,.local} setf bash
autocmd MyAutoCmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
autocmd MyAutoCmd BufRead,BufNewFile *.ts setf filetype=typescript
autocmd MyAutoCmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
