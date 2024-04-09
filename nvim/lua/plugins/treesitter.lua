return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  build = ":TSUpdate",
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'javascript',
      'typescript',
      'tsx',
      'vue',
      'css',
      'html',
      'json',
      'lua',
      'bash',
      'markdown_inline',
      'markdown',
      'scss',
      'toml',
      'vim'
    },
    additional_vim_regex_highlighting = false,
    highlight = { enable = true },
  },
}
