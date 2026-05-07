vim.filetype.add {
  filename = {
    ['.zshrc.local'] = 'zsh',
    ['.zprofile.local'] = 'zsh',
    ['Procfile'] = 'procfile',
  },
  pattern = {
    ['%.env%..*'] = 'sh',
    ['Procfile%..*'] = 'procfile',
  },
}

vim.treesitter.language.register('tsx', 'typescriptreact')
