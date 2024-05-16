return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
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
      'vim',
      'vimdoc'
    },
    additional_vim_regex_highlighting = false,
    highlight = { enable = false },
  },
  init = function()
    vim.uv.new_timer():start(300, 0, vim.schedule_wrap(function()
      vim.cmd 'TSEnable highlight'
    end))
  end
}
