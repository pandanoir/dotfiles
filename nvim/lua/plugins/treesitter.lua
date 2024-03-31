return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VimEnter',
  build = function()
    local ts_update = require 'nvim-treesitter.install'.update { with_sync = true }
    ts_update()
  end,
  init = function()
    vim.defer_fn(function()
      vim.cmd [[TSEnable highlight]]
    end, 50)
  end,
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
      'markdown_inline',
      'markdown',
      'scss',
      'toml',
      'vim'
    },
    additional_vim_regex_highlighting = false,
  },
}
