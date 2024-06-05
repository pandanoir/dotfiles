return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = ':TSUpdate',
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
    textsubjects = {
      enable = true,
      prev_selection = ',',
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-container-outer',
        ['i;'] = 'textsubjects-container-inner',
      },
    },
  },
  init = function()
    vim.uv.new_timer():start(300, 0, vim.schedule_wrap(function()
      vim.cmd 'TSEnable highlight'
    end))
  end,
  dependencies = {
    'RRethy/nvim-treesitter-textsubjects',
  }
}
